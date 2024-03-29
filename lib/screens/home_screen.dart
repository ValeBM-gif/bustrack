//APIIIII: AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY
import 'dart:convert';
import 'dart:ffi';
import 'package:bustrackk/main.dart';
import 'package:bustrackk/models/parada.dart';
import 'package:bustrackk/screens/loginBus_screen.dart';
import 'package:bustrackk/screens/map_screen.dart';
import 'package:bustrackk/widgets/home_ruta_tile.dart';
import 'package:bustrackk/widgets/lista_busquedas_recientes.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:http/http.dart' as http;

import '../models/ruta.dart';
import '../providers/bus_location_provider.dart';
import '../widgets/rutas_list_view.dart';

Future<List> getSugerenciasLugares(String input) async {
  String url =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&key=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> predictions = json.decode(response.body)['predictions'];
    List suggestions = predictions.map((prediction) {
      return prediction['description'];
    }).toList();
    print('suggestions: $suggestions');
    return suggestions;
  } else {
    print("fallastee");
    throw Exception('Failed to load suggestions');
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late maps.LatLng searchedLoc;
  bool mostrarOpcionesRutas = false;
  bool busquedasRecientesExpanded = false;
   maps.LatLng coordsDestinoBarraBusqueda = maps.LatLng(21.156024, -101.694192);

  @override
  void initState() {
    super.initState();
    mostrarOpcionesRutas = false;
  }

  Future<void> getPlaceDetails(String placeId) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print('ya hay respuesta, 200');
      print(response.body);

      Map<String, dynamic> json = jsonDecode(response.body);
      getLatLongFromJson(json);
    } else {
      // Si la solicitud falla, maneja el error aquí.
      throw Exception('Error al cargar detalles del lugar');
    }
  }

  void getLatLongFromJson(Map<String, dynamic> json) {
    var result = json['result'];
    var geometry = result['geometry'];
    var location = geometry['location'];

    var latitud = location['lat'];
    var longitud = location['lng'];
    searchedLoc = maps.LatLng(latitud, longitud);
    print('Latitud: $latitud, Longitud: $longitud');
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: kIconsColor),
        leading: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MapScreen(
                          posicionCamara: userLocation!,
                          deDondeProviene: 1,
                          paradas: paradas,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white38, width: 1.3),
                      borderRadius: const BorderRadius.all(Radius.circular(9))),
                  child: const Icon(
                    Icons.map_outlined,
                    color: kIconsColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/rutas');
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white38, width: 1.3),
                    borderRadius: const BorderRadius.all(Radius.circular(9))),
                child: const Icon(
                  Icons.alt_route,
                  color: kIconsColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
        ],
      ),
      backgroundColor: colorScaffold,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          mostrarOpcionesRutas = false;
                          setState(() {});
                        },
                        child: const Text(
                          'Bustrack',
                          textAlign: TextAlign.start,
                          style: kTextStyleTitles,
                        ),
                      ),
                      const Text(
                        'Movilidad eficiente para ti.',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 14,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 78.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginBusScreen();
                            },
                          ),
                        );
                      },
                      child: Icon(
                        Icons.directions_bus_rounded,
                        size: 60,
                        color: Colors.grey.shade300,
                      )),
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: 3,
              color: kSecondaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: SizedBox(
                width: 500,
                //height: 50,
                child: GooglePlaceAutoCompleteTextField(
                  textStyle: const TextStyle(color: Colors.white),
                  boxDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade700,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  textEditingController: controller,
                  googleAPIKey: "AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY",
                  inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: ' ¿A dónde quieres ir?'),
                  debounceTime: 800,
                  // default 600 ms,
                  countries: const ["mx"],
                  // optional by default null is set
                  isLatLngRequired: true,
                  // if you required coordinates from place detail
                  getPlaceDetailWithLatLng: (Prediction prediction) {
                    //
                  },
                  // this callback is called when isLatLngRequired is true
                  itemClick: (Prediction prediction) async {
                    controller.text = prediction.description!;
                    controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length));

                    await getPlaceDetails(prediction.placeId!);
                    print('ya paso getPlaceDetails');

                    mostrarOpcionesRutas = true;
                    prediccionElegida = prediction;
                    print('prediccionElegida ya tiene algo $prediccionElegida');
                    //coordsDestinoBarraBusqueda = maps.LatLng(double.parse(prediccionElegida!.lat!), double.parse(prediccionElegida!.lat!));
                    setState(() {});
                    FocusManager.instance.primaryFocus?.unfocus();
                    //Navigator.pushNamed(context, '/mapa');
                    //controller.text = '';
                  },
                  itemBuilder: (context, index, Prediction prediction) {
                    return Container(
                      color: Colors.grey.shade900,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                              child: Text(
                            prediction.description ?? "",
                            style: TextStyle(color: Colors.white),
                          ))
                        ],
                      ),
                    );
                  },
                  seperatedBuilder: const Divider(
                    height: 0,
                  ),
                  isCrossBtnShown: true,
                ),
              ),
            ),
            mostrarOpcionesRutas
                ? prediccionElegida != null
                    ? Column(
                        children: [
                          HomeRutaTile(
                            ruta:
                                rutas.firstWhere((element) => element.id == 10),
                            prediction: prediccionElegida!,
                            coordenadasDestino: maps.LatLng(
                              double.parse(prediccionElegida!.lat!),
                              double.parse(prediccionElegida!.lng!),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          HomeRutaTile(
                            ruta:
                                rutas.firstWhere((element) => element.id == 11),
                            prediction: prediccionElegida!,
                            coordenadasDestino: maps.LatLng(
                              double.parse(prediccionElegida!.lat!),
                              double.parse(prediccionElegida!.lng!),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          HomeRutaTile(
                            ruta:
                                rutas.firstWhere((element) => element.id == 2),
                            prediction: prediccionElegida!,
                            coordenadasDestino: maps.LatLng(
                              double.parse(prediccionElegida!.lat!),
                              double.parse(prediccionElegida!.lng!),
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Búsquedas Recientes',
                              style: kTextStyleTitles.copyWith(fontSize: 24),
                            ),
                            GestureDetector(
                              onTap: () {
                                busquedasRecientesExpanded =
                                    !busquedasRecientesExpanded;
                                setState(() {});
                              },
                              child: Text(
                                !busquedasRecientesExpanded
                                    ? 'Ver todas...'
                                    : 'Ver menos...',
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: kSecondaryColor,
                                    decorationColor: kSecondaryColor),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: busquedasRecientesExpanded ? 270 : 100,
                              child: GestureDetector(
                                  onTap: () {
                                    mostrarOpcionesRutas = true;
                                    setState(() {});
                                  },
                                  child: const ListaBusquedasRecientes()),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Image.asset(
                                'assets/images/parada.png',
                                height: busquedasRecientesExpanded ? 100 : 230,
                                width: busquedasRecientesExpanded ? 100 : 230,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
