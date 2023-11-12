import 'package:bustrackk/models/ruta.dart';
import 'package:bustrackk/screens/home_screen.dart';
import 'package:bustrackk/screens/map_screen.dart';
import 'package:bustrackk/screens/routes_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'constants.dart';

String apiKey = 'AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY';
LatLng? userLocation = LatLng(21.125012, -101.685966);
LatLng? destinoLocation;
LatLng? inicioRuta;
LatLng? finRuta;
bool mostrarCamaraAutomatica = true;
bool mostrarRuta = false;
Ruta? rutaAMostrar;
Prediction? prediccionElegida;

void main() {
  runApp(MyApp());
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

  int _currenPagetIndex = 0;

  void _cambiarDeScreen(
  int index, LatLng userLoc, LatLng? destinoLoc, bool camaraAutomatica, LatLng?  inRuta, LatLng?  fRuta, bool showRuta, Ruta? ruta, Prediction? prediction) {
    setState(() {
      userLocation = userLoc;
      destinoLocation = destinoLoc;
      _currenPagetIndex = index;
      mostrarCamaraAutomatica = camaraAutomatica;
      inicioRuta=inRuta;
      finRuta=fRuta;
      mostrarRuta=showRuta;
      rutaAMostrar=ruta;
      prediccionElegida=prediction;
    });
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
        '/mapa': (context) => MapScreen(
              tiempoDeLlegada: 1,
              posicionDeDestino: destinoLocation,
              posicionUsuario: userLocation ?? const LatLng(20.15, -100.7),
              mostrarCamaraPosicionUsuario: mostrarCamaraAutomatica,
              posicionCamara:
                  mostrarCamaraAutomatica ? userLocation! : destinoLocation!=null?destinoLocation!:inicioRuta!,
              mostrarRuta: mostrarRuta,
              posicionFinRuta: finRuta,
              posicionInicioRuta: inicioRuta,
          ruta: rutaAMostrar,
          prediction: prediccionElegida,
            ),
        '/rutas': (context) => RoutesScreen(irAMapa: _cambiarDeScreen),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          // This is handled by the search bar itself.
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.black.withAlpha(230),
            currentIndex: _currenPagetIndex,
            onTap: (index) {
              _cambiarDeScreen(index,
                  userLocation ?? const LatLng(20.15, -100.7), null, true, inicioRuta,finRuta, mostrarRuta, null, null);
            },
            items: const [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.home,
                  color: kPrimaryColor,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.map,
                  color: kPrimaryColor,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.alt_route,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          body: IndexedStack(
            index: _currenPagetIndex,
            children: [
              HomeScreen(
                irAMapa: _cambiarDeScreen,
              ),
              MapScreen(
                tiempoDeLlegada: 15,
                posicionDeDestino: destinoLocation,
                posicionUsuario: userLocation ?? const LatLng(20.15, -100.7),
                mostrarCamaraPosicionUsuario: mostrarCamaraAutomatica,
                posicionCamara:
                    mostrarCamaraAutomatica ? userLocation! : destinoLocation!=null?destinoLocation!:inicioRuta!,
                mostrarRuta: mostrarRuta,
                posicionInicioRuta: inicioRuta,
                posicionFinRuta: finRuta,
                ruta: rutaAMostrar,
                prediction: prediccionElegida,
              ),
              RoutesScreen(irAMapa: _cambiarDeScreen),
            ],
          )
        ),
      ),
    );
  }
}
