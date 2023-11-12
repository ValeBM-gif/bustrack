import 'dart:async';
import 'package:bustrackk/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter_map/flutter_map.dart';
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
  maps.LatLng posicionUsuario;
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
    required this.posicionUsuario,
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

  poly.GoogleMapPolyline googleMapPolyline =
      poly.GoogleMapPolyline(apiKey: apiKey);
  //final List<maps.Polyline> polylines = [];

  List<maps.LatLng> routeCoords = [];
  //Map<PolylineId, maps.Polyline> polylines = {};

  final Set<maps.Polyline> _polyline = {};

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // computePath(inicio, fin) async {
  //   routeCoords.addAll((await googleMapPolyline.getCoordinatesWithLocation(
  //       origin: inicio,
  //       destination: fin,
  //       mode: poly.RouteMode.walking)) as Iterable<maps.LatLng>);
  //
  //   setState(() {
  //     polylines.add(
  //         maps.Polyline(
  //           polylineId: const maps.PolylineId('iter'),
  //           visible: true,
  //           points: routeCoords,
  //           width: 4,
  //           geodesic: true,
  //           color: Colors.red,
  //           startCap: Cap.roundCap,
  //           endCap: Cap.buttCap),
  //     );
  //   });
  //
  //   print('routecoords: $routeCoords');
  // }

  // This functions gets real road polyline routes
  getDirections(inicio, fin) async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> polylineWayPoints = [];

      polylineWayPoints.add(PolylineWayPoint(location: "21.124986, -101.685913",stopOver: true));
    polylineWayPoints.add(PolylineWayPoint(location: "20.748305, -101.453808",stopOver: true));

    PolylinePoints polylinePoints = PolylinePoints();
// result gets little bit late as soon as in video, because package // send http request for getting real road routes
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey, //GoogleMap ApiKey
      const PointLatLng(21.124986, -101.685913), //first added marker
      const PointLatLng(20.748305, -101.453808), //last added marker
// define travel mode driving for real roads
      travelMode: TravelMode.driving,
// waypoints is markers that between first and last markers
  wayPoints: polylineWayPoints

    );
// Sometimes There is no result for example you can put maker to the // ocean, if results not empty adding to polylineCoordinates
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        print("LAT ADDED");
      });
    } else {
      print(result.errorMessage);
    }

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
  void initState() {
    super.initState();
    inicializarDatosMapa();
    _loadMapStyles();
    _setMapStyle();
    generarMarkers();
  }

  @override
  void dispose() {
    _marcadores.removeWhere((marker) => marker.markerId == '2');
    super.dispose();
  }

  void inicializarDatosMapa() async {
    //Camera Position
    if (widget.mostrarRuta) {
      widget.posicionCamara = widget.posicionInicioRuta!;
    } else {
      if (widget.mostrarCamaraPosicionUsuario) {
        widget.posicionCamara = widget.posicionUsuario;
      } else {
        widget.posicionCamara = widget.posicionDeDestino!;
      }
    }

    _posicionCamara = maps.CameraPosition(
      target: maps.LatLng(
          widget.posicionCamara!.latitude, widget.posicionCamara!.longitude),
      zoom: 14.4746,
    );



    // Markers List

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
    if (!widget.mostrarRuta) {
      if (!widget.mostrarCamaraPosicionUsuario) {
        _marcadores.add(
          maps.Marker(
            markerId: const maps.MarkerId('2'), // Puedes usar un ID diferente
            position: widget
                .posicionDeDestino!, // Latitud y longitud del nuevo marcador
            infoWindow: const maps.InfoWindow(
              title: 'Ubicación buscada',
            ),
          ),
        );
      }
    }


    _marcadores.add(
      maps.Marker(
        markerId: const maps.MarkerId('1'),
        position: maps.LatLng(widget.posicionUsuario!.latitude,
            widget.posicionUsuario!.longitude),
        infoWindow: const maps.InfoWindow(
          title: 'Estás aquí',
        ),
      ),
    );

    final Uint8List customMarker = await getBytesFromAsset(
        path:
        'https://png.pngtree.com/png-vector/20220907/ourmid/pngtree-bus-stop-sign-png-image_6140912.png', //paste the custom image path
        width: 50 // size of custom image as marker
    );

    for (var parada in paradas) {
      _marcadores.add(
        maps.Marker(
          icon: BitmapDescriptor.fromBytes(customMarker),
          markerId:
          maps.MarkerId('${parada.id}'), // Puedes usar un ID diferente
          position: parada.posicion, // Latitud y longitud del nuevo marcador
          infoWindow: maps.InfoWindow(
            title: parada.direccion,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('cuantos marcadores hay al constuir ${_marcadores.length}');
    for (var marcador in _marcadores) {
      print('id: ${marcador.markerId}, title: ${marcador.infoWindow.title}');
    }
    if (!widget.mostrarRuta) {
      if (!widget.mostrarCamaraPosicionUsuario) {
        print('entra a añadir marker ubi actual');
        //computePath(widget.posicionUsuario, widget.posicionDeDestino!);
        getDirections(widget.posicionUsuario, widget.posicionDeDestino!);
        print(_polyline)   ;
        print("polis")  ;
      }
    } else {
      getDirections(widget.posicionInicioRuta, widget.posicionFinRuta!);
      //computePath(widget.posicionInicioRuta, widget.posicionFinRuta);
      print(_polyline)   ;
    } print("polis")  ;
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
      body:
          maps.GoogleMap(
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
           
            )

    );
  }
}
