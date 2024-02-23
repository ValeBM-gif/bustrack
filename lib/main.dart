import 'package:bustrackk/models/ruta.dart';
import 'package:bustrackk/providers/bus_location_provider.dart';
import 'package:bustrackk/screens/home_screen.dart';
import 'package:bustrackk/screens/routes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'constants.dart';
import 'package:provider/provider.dart';

String apiKey = 'AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY';
LatLng? userLocation = const LatLng(21.125012, -101.685966);
LatLng? destinoLocation;
LatLng? inicioRuta;
LatLng? finRuta;
bool mostrarCamaraAutomatica = true;
bool mostrarRuta = false;
Ruta? rutaAMostrar;
Prediction? prediccionElegida;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final busLocationProvider = BusLocationProvider();
  busLocationProvider.initFromFirebase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: busLocationProvider),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void checkPermissions() async {
    print('entra a pedir permisos');
    Future<Position> getPosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test servicios ubicación
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Ubicación apagada
        throw Exception('Servicios de ubicación desactivados.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // No hay permisos
          throw Exception('Servicios de ubicación desactivados');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // No hay permisos nunca
        throw Exception('Servicios de ubicación desactivados.');
      }

      // Permisos concedidos
      debugPrint("PERMISOS CONCEDIDOS");
      return await Geolocator.getCurrentPosition();
    }

    var pos = await getPosition();
    setState(() {
      userLocation = LatLng(pos.latitude, pos.longitude);
    });
    print('asigna user loc: ${pos.latitude}, ${pos.longitude}');
  }

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    print('construye myapp, main con coordenadas ${userLocation}');
    return MaterialApp(
        theme: ThemeData.dark(),
        routes: {
          '/rutas': (context) => RoutesScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const HomeScreen());
  }
}
