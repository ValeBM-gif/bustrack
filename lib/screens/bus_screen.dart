import 'dart:async';
import 'package:bustrackk/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:location/location.dart';
import '../constants.dart';

class BusScreen extends StatefulWidget {
  const BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
  final Completer<maps.GoogleMapController> _mapController = Completer();
  late maps.CameraPosition _posicionCamara;
  LocationData? currentLocation;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _posicionCamara = maps.CameraPosition(
      target: maps.LatLng(userLocation!.latitude, userLocation!.longitude),
      zoom: 14.4746,
    );
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Location location = Location();
    var newLocat;

    location.getLocation().then((loc) => currentLocation = loc);

    maps.GoogleMapController googleMapController = await _mapController.future;

    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      googleMapController.animateCamera(
        maps.CameraUpdate.newCameraPosition(
          maps.CameraPosition(
            target: maps.LatLng(newLoc.latitude!, newLoc.longitude!),
          ),
        ),
      );

      newLocat=newLoc;
      setState(() {});
    });

    var doc = await firestore.collection('coordenadasUsuario').add({
      'lat': newLocat.latitude,
      'lon':newLocat.longitude
    });
    print('¿ ${doc.path}');
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: const Column(
            children: [
              Text('Autobusito'),
            ],
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: currentLocation==null?Center(child: CircularProgressIndicator(),):maps.GoogleMap(
          onMapCreated: (maps.GoogleMapController controller) {
            _mapController.complete(controller);
          },
          //polylines: _polyline,
          initialCameraPosition: maps.CameraPosition(target: maps.LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 13.5),
          //markers: Set<maps.Marker>.of(_marcadores),
          mapType: maps.MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          //polylines: Set.from(polylines),
        ));
  }
}
