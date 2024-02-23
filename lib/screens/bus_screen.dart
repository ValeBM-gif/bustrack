import 'dart:async';
import 'package:bustrackk/main.dart';
import 'package:bustrackk/providers/bus_location_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

LocationData? busCurrentLocation;
maps.LatLng locationFake = const maps.LatLng(33.106496, 82.292122);

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  final Completer<maps.GoogleMapController> _mapController = Completer();

  late maps.CameraPosition _posicionCamara;
  final firestore = FirebaseFirestore.instance;
  late Timer _timer;
  late Timer _timerFakeMovement;
  late double initialFakeLat;
  late double initialFakeLon;
  late String _busMapStyle;
  late List<maps.Marker> _marcadores = [];

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
    _setMapStyle();
    _posicionCamara = maps.CameraPosition(
      target: maps.LatLng(userLocation!.latitude, userLocation!.longitude),
      zoom: 14.4746,
    );
    initVariables();
  }

  Future _loadMapStyles() async {
    _busMapStyle =
        await rootBundle.loadString('assets/map_styles/map_style2.json');
  }

  Future _setMapStyle() async {
    final controller = await _mapController.future;
    final theme = WidgetsBinding.instance.window.platformBrightness;
    controller.setMapStyle(_busMapStyle);
  }

  Future<void> initVariables() async {
    if (getCurrentLocation() != null) {
      busCurrentLocation = await getCurrentLocation();
      print('bus current loc ${busCurrentLocation!.latitude}');
      context.read<BusLocationProvider>().setBusLoc(busCurrentLocation);
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateLocationToFirebase();
    });
  }

  Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    late LocationData locData;

    try {
      print('get current location');
      locData = await location.getLocation();
      setState(() {});
      return locData;
    } catch (e) {
      print('todo mal');
    }
    return null;
  }

  Future<void> updateLocationToFirebase() async {
    print('entra a updt fb');
    if (busCurrentLocation != null) {
      print('update location to firebase');
      LocationData lastLocation = busCurrentLocation!;
      LocationData? newLocation = await getCurrentLocation();
      if(newLocation!=null){
        if (lastLocation != newLocation) {
          print('diferencia de loc anterior y actual');
          busCurrentLocation = newLocation;
          setMarker(busCurrentLocation);
          var docAUpdatear =
          firestore.collection('coordenadasUsuario').doc('bus');
          docAUpdatear.update({
            'lat': newLocation!.latitude,
            'lon': newLocation!.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
        context.read<BusLocationProvider>().setBusLoc(newLocation);
      }else{
        print('new location es null');
      }

    } else {
      print('bus current loc null');
    }
  }

  void setMarker(markerLocation){
    _marcadores.add(
      maps.Marker(
        markerId: const maps.MarkerId('2'),
        position: maps.LatLng(
            markerLocation.latitude!,
            markerLocation
                .longitude!), // Latitud y longitud del nuevo marcador
        infoWindow: const maps.InfoWindow(
          title: 'Camionsito está aquí:)',
        ),
      ),
    );
    print('marker added');
    setState(() {});
  }

  void fakeChangeLocation(){
    print('entra a cambiar loc');
    initialFakeLat+=.001;
    initialFakeLon+=.001;
    busCurrentLocation?.latitude!=initialFakeLat;
    busCurrentLocation?.longitude!=initialFakeLon;
  }


  @override
  void dispose() {
    _timer.cancel();
    _timerFakeMovement.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Autobusito'),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: busCurrentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : maps.GoogleMap(
              onMapCreated: (maps.GoogleMapController controller) {
                _mapController.complete(controller);
              },
              //polylines: _polyline,
              initialCameraPosition: maps.CameraPosition(
                  target: maps.LatLng(busCurrentLocation!.latitude!,
                      busCurrentLocation!.longitude!),
                  zoom: 14.4746),
              markers: Set<maps.Marker>.of(_marcadores),
              mapType: maps.MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              //polylines: Set.from(polylines),
            ),
    );
  }
}
