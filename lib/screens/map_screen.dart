import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart' as poly;
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../constants.dart';
import '../main.dart';
import '../models/parada.dart';
import '../models/ruta.dart';

class MapScreen extends StatefulWidget {
  double? tiempoDeLlegada;
  maps.LatLng posicionCamara;
  maps.LatLng? posicionDeDestino;
  maps.LatLng? posicionInicioRuta;
  maps.LatLng? posicionFinRuta;
  bool mostrarCamaraPosicionUsuario;
  bool mostrarRuta;
  Ruta? ruta;
  Prediction? prediction;

  MapScreen({
    super.key,
    required this.tiempoDeLlegada,
    this.posicionDeDestino,
    required this.mostrarCamaraPosicionUsuario,
    required this.posicionCamara,
    required this.mostrarRuta,
    this.posicionFinRuta,
    this.posicionInicioRuta,
    this.ruta,
    this.prediction,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<maps.GoogleMapController> _mapController = Completer();

  late maps.CameraPosition _posicionCamara;
  late List<maps.Marker> _marcadores = [];

  late String _darkMapStyle;

  List<maps.LatLng> routeCoords = [];
  //Map<PolylineId, maps.Polyline> polylines = {};

  Set<maps.Polyline> _polyline = {};

  @override
  void initState() {
    super.initState();
    inicializarDatosMapa();
    _loadMapStyles();
    _setMapStyle();
    generarMarkers();
  }

  void inicializarDatosMapa() async {
    //Camera Position
    //_polyline = {};
    if (widget.mostrarRuta) {
      widget.posicionCamara = widget.posicionInicioRuta!;
    } else {
      if (widget.mostrarCamaraPosicionUsuario) {
        widget.posicionCamara = userLocation!;
      } else {
        widget.posicionCamara = widget.posicionDeDestino!;
      }
    }

    _posicionCamara = maps.CameraPosition(
      target: maps.LatLng(
          widget.posicionCamara!.latitude, widget.posicionCamara!.longitude),
      zoom: 14.4746,
    );
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
    //IR A MAPA POR SEARCH BAR
    print('de donde venimos');
    print('clic normal en mapa ${widget.mostrarCamaraPosicionUsuario}');
    print('rutas page ${widget.mostrarRuta}');
    if (!widget.mostrarRuta) {
      if (!widget.mostrarCamaraPosicionUsuario) {
        _marcadores.add(
          maps.Marker(
            markerId: const maps.MarkerId('2'),
            position: widget
                .posicionDeDestino!, // Latitud y longitud del nuevo marcador
            infoWindow: const maps.InfoWindow(
              title: 'Ubicación buscada',
            ),
          ),
        );
      }
    }

    //MARKERS POR PARADA
    // for (var parada in paradas) {
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
  }

  //DUDOSO
  // This functions gets real road polyline routes
  getDirections(inicio, fin) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> polylineWayPoints = [];

    polylineWayPoints.add(
        PolylineWayPoint(location: "21.124986, -101.685913", stopOver: true));
    polylineWayPoints.add(
        PolylineWayPoint(location: "20.748305, -101.453808", stopOver: true));

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
    if (widget.posicionCamara != oldWidget.posicionCamara) {
      actualizarCamara();
    }
  }

  void actualizarCamara() async {
    final maps.GoogleMapController controller = await _mapController.future;
    controller
        .animateCamera(maps.CameraUpdate.newLatLng(widget.posicionCamara));
  }

  @override
  void dispose() {
    _marcadores.removeWhere((marker) => marker.markerId == '2');
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    inicializarDatosMapa();

    //SI LLEGAMOS A TRAVÉS DE SEARCH BAR
    if (!widget.mostrarRuta) {
      if (!widget.mostrarCamaraPosicionUsuario) {
        generarMarkers();
        getDirections(PointLatLng(userLocation!.latitude, userLocation!.longitude), PointLatLng(widget.posicionDeDestino!.latitude, widget.posicionDeDestino!.longitude));
        print(_polyline);
        print("polis");
      }
    } else {
      getDirections(PointLatLng(widget.posicionInicioRuta!.latitude, widget.posicionInicioRuta!.longitude), PointLatLng(widget.posicionFinRuta!.latitude, widget.posicionFinRuta!.longitude));
      print('polis: $_polyline');
    }

    return Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(
                widget.mostrarCamaraPosicionUsuario
                    ? 'Paradas Cercanas'
                    : widget.mostrarRuta
                        ? 'Ruta ${widget.ruta!.nombre}'
                        : widget.prediction!.description!,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          backgroundColor: kPrimaryColor,
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
        ));
  }
}
