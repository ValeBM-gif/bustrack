import 'dart:async';
import 'package:bustrackk/providers/bus_location_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../main.dart';
import '../models/parada.dart';
import '../models/ruta.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  final maps.LatLng posicionCamara;
  maps.LatLng? posicionDeDestino;
  final int deDondeProviene; //1 solo mapa, 2 destino (search bar), 3 rutas
  Ruta? ruta;
  Prediction? prediction;
  List<Parada>? paradas;

  MapScreen(
      {super.key,
      required this.posicionCamara,
      this.ruta,
      this.prediction,
      required this.deDondeProviene,
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

  Set<maps.Polyline> _polyline = {};

  @override
  void initState() {
    super.initState();
    inicializarDatosMapa();
    _loadMapStyles();
    _setMapStyle();
    generarMarkers();
    //BUS LOCATION
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      generarBusMarkers();
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

  Future<void> generarMarkers() async {
    if (widget.deDondeProviene == 2) {
      _marcadores.add(
        maps.Marker(
          markerId: const maps.MarkerId('2'),
          position:
              _posicionCamara.target, // Latitud y longitud del nuevo marcador
          infoWindow: maps.InfoWindow(
            title: widget.prediction!.description,
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

  void generarBusMarkers() async{
    print('generarBusMarkers');
    print(context.read<BusLocationProvider>().getBusLoc!.latitude!);

    CollectionReference coordenadasUsuario =
    FirebaseFirestore.instance.collection('coordenadasUsuario');

    try{
      DocumentSnapshot document =
      await coordenadasUsuario.doc('bus').get();
      var lat = document['lat'];
      var lon = document['lon'];
      print('doc: $document');
      print('lat: $lat');
      print('lon: $lon');

      _marcadores.add(
        maps.Marker(
          icon: markerIcon,
          markerId: const maps.MarkerId('0'),
          position: maps.LatLng(
              lat,
              lon), // Latitud y longitud del nuevo marcador
          infoWindow: const maps.InfoWindow(
            title: 'Camionsito está aquí:)',
          ),
        ),
      );
      setState(() {});
    }catch(e){
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
      if (widget.deDondeProviene == 2) {
        //todo: hacer polyline de camino a tomar para llegar a destino
      }
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white60, //change your color here
        ),
        title: SizedBox(
          width: 250,
          child: Text(
            widget.deDondeProviene == 1
                ? 'Paradas Cercanas'
                : widget.deDondeProviene == 3
                    ? 'Ruta ${widget.ruta!.nombre}'
                    : widget.prediction!.description!,
            style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SlidingUpPanel(
        slideDirection: SlideDirection.UP,
        backdropColor: Colors.pink,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        color: Colors.black54,
        border: const Border(
            bottom: BorderSide(color: Colors.transparent, width: 3),
            left: BorderSide(color: Colors.transparent, width: 3),
            right: BorderSide(color: Colors.transparent, width: 3)),
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        minHeight: widget.deDondeProviene == 1 ? 0 : 20,
        maxHeight: 240,
        panel: Center(
          child: Text('panel'),
        ),
        body: maps.GoogleMap(
          onMapCreated: (maps.GoogleMapController controller) {
            _mapController.complete(controller);
          },
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