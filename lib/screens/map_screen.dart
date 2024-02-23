import 'dart:async';
import 'package:bustrackk/providers/bus_location_provider.dart';
import 'package:bustrackk/widgets/instruccion_separator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main.dart';
import '../models/lugar.dart';
import '../models/parada.dart';
import '../models/ruta.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';
import '../widgets/instruccion.dart';
import '../widgets/rutas_list_view.dart';

final pController = PanelController();

class MapScreen extends StatefulWidget {
  final maps.LatLng posicionCamara;
  maps.LatLng? posicionDeDestino;
  final int deDondeProviene; //1 solo mapa, 2 destino (search bar), 3 rutas
  Ruta? ruta;
  Prediction? prediction;
  List<Parada>? paradas;
  Lugar? lugar;

  MapScreen(
      {super.key,
      required this.posicionCamara,
      this.ruta,
      this.prediction,
      required this.deDondeProviene,
      this.lugar,
      this.paradas});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<maps.GoogleMapController> _mapController = Completer();

  late maps.CameraPosition _posicionCamara;
  late List<maps.Marker> _marcadores = [];

  late String _darkMapStyle;
  late Timer _timer;
  late BitmapDescriptor markerIcon;
  bool expandAddress = false;
  var textoPanel = '';
  Set<maps.Polyline> _polyline = {};

  var selected1 = true;
  var selected2 = false;
  var selected3 = false;
  var avisame = true;

  var latBus;
  var lonBus;
  var cercaniaBus;
  bool mostrarToast = true;

  late FToast fToast;

  var tiempoLlegadaBusAMi;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    inicializarDatosMapa();
    _loadMapStyles();
    _setMapStyle();
    generarMarkers();
    //BUS LOCATION
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      generarBusMarkers();
      if (mostrarToast) {
        if (latBus != null && lonBus != null) {
          if (checarCercaniaBus(userLocation!.latitude, userLocation!.longitude,
              latBus, lonBus)) {
            _showToast(
                "Tu camión está a ${cercaniaBus.round()} metros aprox,\n llega en $tiempoLlegadaBusAMi segundos aprox.");
            //, llega en $tiempoLlegadaBusAMi segundos aprox.
            mostrarToast = false;
          }
        }
      }
    });
  }

  void inicializarDatosMapa() async {
    _posicionCamara = maps.CameraPosition(
      target: maps.LatLng(
          widget.posicionCamara!.latitude, widget.posicionCamara!.longitude),
      zoom: 14.4746,
    );

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(
              size: Size(40, 40),
            ),
            'assets/images/autobus2.png')
        .then((value) => markerIcon = value);
    if (widget.deDondeProviene == 2) {
      textoPanel = widget.prediction!.description!;
    } else if (widget.deDondeProviene == 3) {
      textoPanel = '${widget.ruta!.nombre}, ${widget.ruta!.direccion}';
    }
  }

  Future _loadMapStyles() async {
    _darkMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style.json');
  }

  Future _setMapStyle() async {
    final controller = await _mapController.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    controller.setMapStyle(_darkMapStyle);
  }

  _showToast(texto) {
    Widget toast = Container(
      //height: 60,
      width: 280,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white70,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bus_alert_rounded,
            color: Colors.grey.shade800,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            texto,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
                fontSize: 12),
          ),
        ],
      ),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: const Duration(seconds: 10),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 20.0,
            left: 50.0,
          );
        });
  }

  Future<void> generarMarkers() async {
    if (widget.deDondeProviene == 2 || widget.deDondeProviene == 4) {
      _marcadores.add(
        maps.Marker(
          markerId: const maps.MarkerId('2'),
          position: maps.LatLng(
            double.parse(widget.prediction!.lat!),
            double.parse(widget.prediction!.lng!),
          ), // Latitud y longitud del nuevo marcador
          infoWindow: maps.InfoWindow(
            title: textoPanel,
          ),
        ),
      );
      //todo: marker de paradas o puntos necesaries para llegar a destino
    } else {
      //MARKERS POR PARADA
      // for (var parada in widget.paradas) {
      //   _marcadores.add(
      //     maps.Marker(
      //       //icon: BitmapDescriptor.fromBytes(customMarker),
      //       markerId: maps.MarkerId('${parada.id}'),
      //       position: parada.posicion,
      //       infoWindow: maps.InfoWindow(
      //         title: parada.direccion,
      //       ),
      //     ),
      //   );
      // }
      //todo: checar que paradas vamos a hardcodear
      //todo: generar markers de paradas dentro de la ruta seleccionada
    }
  }

  bool checarCercaniaBus(
      double userLat, double userLng, double busLat, double busLng) {
    const double earthRadius = 6371000; // Radio de la Tierra en metros
    double lat1Rad = userLat * (pi / 180);
    double lng1Rad = userLng * (pi / 180);
    double lat2Rad = busLat * (pi / 180);
    double lng2Rad = busLng * (pi / 180);

    double dLat = lat2Rad - lat1Rad;
    double dLng = lng2Rad - lng1Rad;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLng / 2) * sin(dLng / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    cercaniaBus = distance;
    print(userLat);
    print(userLng);
    print('distancia $distance');

    tiempoLlegadaBusAMi = (distance / 5).round();

    return distance <= 100;
  }

  void generarBusMarkers() async {
    print('generarBusMarkers');
    //print(context.read<BusLocationProvider>().getBusLoc!.latitude!);

    CollectionReference coordenadasUsuario =
        FirebaseFirestore.instance.collection('coordenadasUsuario');

    try {
      DocumentSnapshot document = await coordenadasUsuario.doc('bus').get();
      var lat = document['lat'];
      var lon = document['lon'];
      print('doc: $document');
      print('lat: $lat');
      print('lon: $lon');
      latBus = lat;
      lonBus = lon;
      _marcadores.add(
        maps.Marker(
          icon: markerIcon,
          markerId: const maps.MarkerId('0'),
          position:
              maps.LatLng(lat, lon), // Latitud y longitud del nuevo marcador
          infoWindow: const maps.InfoWindow(
            title: 'Camionsito está aquí:)',
          ),
        ),
      );
      setState(() {});
    } catch (e) {
      print('error en generarBusMarkers $e');
    }
  }

  //DUDOSO
  // This functions gets real road polyline routes
  getDirections(inicio, fin) async {
    List<LatLng> polylineCoordinates = [];

    //PUNTOS ESPECÍFICOS POR LOS QUE TIENE QUE PASAR
    //List<PolylineWayPoint> polylineWayPoints = [];

    // polylineWayPoints.add(
    //     PolylineWayPoint(location: "21.124986, -101.685913", stopOver: true));
    // polylineWayPoints.add(
    //     PolylineWayPoint(location: "20.748305, -101.453808", stopOver: true));

    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      inicio,
      fin,
      //const PointLatLng(21.124986, -101.685913),
      //const PointLatLng(20.748305, -101.453808),
      travelMode: TravelMode.driving,
// waypoints is markers that between first and last markers
      //wayPoints: polylineWayPoints
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    setState(() {});

    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    maps.Polyline polyline = maps.Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 4,
    );
    _polyline.add(polyline);
  }

  @override
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_posicionCamara != _posicionCamara) {
      actualizarCamara();
    }
  }

  void actualizarCamara() async {
    final maps.GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(maps.CameraUpdate.newLatLng(_posicionCamara.target));
  }

  @override
  void dispose() {
    _marcadores.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //SI LLEGAMOS A TRAVÉS DE SEARCH BAR
    if (widget.deDondeProviene != 1) {
      getDirections(
        PointLatLng(widget.ruta!.posicion1!.latitude,
            widget.ruta!.posicion1!.longitude),
        PointLatLng(widget.ruta!.posicion2!.latitude,
            widget.ruta!.posicion2!.longitude),
      );
      if (widget.deDondeProviene == 2 || widget.deDondeProviene == 4) {
        getDirections(
          PointLatLng(userLocation!.latitude, userLocation!.longitude),
          PointLatLng(
            double.parse(widget.prediction!.lat!),
            double.parse(widget.prediction!.lng!),
          ), // Latitud y longitud del nuevo marcador
        );
      }
    }

    return Scaffold(
      body: SlidingUpPanel(
        controller: pController,
        slideDirection: SlideDirection.UP,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        color: Colors.grey.shade900,
        border: const Border(
            bottom: BorderSide(color: Colors.transparent, width: 3),
            left: BorderSide(color: Colors.transparent, width: 3),
            right: BorderSide(color: Colors.transparent, width: 3)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        minHeight: widget.deDondeProviene == 1 ? 0 : 50,
        maxHeight: widget.deDondeProviene == 1 ? 0 : 550,
        panel: pController.isAttached
            ? pController.isPanelOpen
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Container(
                                color: kPrimaryColor,
                                width: double.infinity,
                                height: 2.5,
                              )),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  checarCercaniaBus(userLocation!.latitude, userLocation!.longitude,
                                      latBus, lonBus);
                                  _showToast("Tu camión está a ${cercaniaBus.round()} metros aprox,\n llega en $tiempoLlegadaBusAMi segundos aprox.");
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: kPrimaryColor, width: 2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.directions_bus_filled_rounded,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Container(
                                color: kPrimaryColor,
                                width: double.infinity,
                                height: 2.5,
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(9),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('18 mins'),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Container(
                                        height: 20,
                                        width: 3,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    DateTime.now().minute < 42
                                        ? Text(
                                            'Hora estimada de llegada: ${DateTime.now().hour}:${DateTime.now().minute + 18}')
                                        : DateTime.now().minute + 18 - 60 < 10
                                            ? Text(
                                                'Hora estimada de llegada: ${DateTime.now().hour}:0${DateTime.now().minute + 18 - 60}')
                                            : Text(
                                                'Hora estimada de llegada: ${DateTime.now().hour}:${DateTime.now().minute + 18 - 60}')
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                expandAddress = !expandAddress;
                              },
                              child: Text(
                                !expandAddress
                                    ? textoPanel.length > 46
                                        ? '${textoPanel.substring(0, 46)}...'
                                        : textoPanel
                                    : textoPanel,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  selected1 = true;
                                  selected2 = false;
                                  selected3 = false;
                                },
                                child: Instruccion(
                                  texto: 'Caminar a parada',
                                  tiempo: '1 min',
                                  icono: Icons.directions_walk,
                                  cosiSeleccionado: selected1,
                                ),
                              ),
                              InstruccionSeparator(),
                              GestureDetector(
                                onTap: () {
                                  selected1 = false;
                                  selected2 = true;
                                  selected3 = false;
                                },
                                child: Instruccion(
                                  texto: 'Tomar ruta L2',
                                  tiempo: '15 mins',
                                  icono: Icons.arrow_forward_sharp,
                                  cosiSeleccionado: selected2,
                                ),
                              ),
                              InstruccionSeparator(),
                              GestureDetector(
                                onTap: () {
                                  selected1 = false;
                                  selected2 = false;
                                  selected3 = true;
                                },
                                child: Instruccion(
                                  texto: 'Caminar a destino',
                                  tiempo: '2 mins',
                                  icono: Icons.directions_walk,
                                  cosiSeleccionado: selected3,
                                ),
                              ),
                              InstruccionSeparator(),
                              Text('Llegaste:)',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
            : const SizedBox(),
        collapsed: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              height: 3,
              width: 60,
            ),
            const SizedBox(
              height: 8,
            ),
            Center(
              child: Text(
                'Cómo llegar...',
                style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        //snapPoint: .5,
        body: maps.GoogleMap(
          onMapCreated: (maps.GoogleMapController controller) {
            _mapController.complete(controller);
          },
          zoomControlsEnabled: false,
          polylines: _polyline,
          initialCameraPosition: _posicionCamara,
          markers: Set<maps.Marker>.of(_marcadores),
          mapType: maps.MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          //polylines: Set.from(polylines),
        ),
      ),
    );
  }
}
