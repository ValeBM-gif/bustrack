//APIIIII: AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY
import 'dart:convert';
import 'package:bustrackk/main.dart';
import 'package:bustrackk/screens/loginBus_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../constants.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:http/http.dart' as http;

import '../models/ruta.dart';

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
  final void Function(int, maps.LatLng, bool, maps.LatLng?, maps.LatLng?, bool,
      Ruta?, Prediction?) irAMapa;
  const HomeScreen({
    super.key,
    required this.irAMapa,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late maps.LatLng searchedLoc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getPlaceDetails(String placeId) async {
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      print('respuesta');
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
      //backgroundColor: Colors.black87,
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: Container(
          width: 200,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Bustrack',
                      textAlign: TextAlign.start,
                      style: kTextStyleTitles,
                    ),
                    Text(
                      'Movilidad eficiente para ti.',
                      style: TextStyle(
                          fontSize: 16,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
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
              color: kPrimaryColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: SizedBox(
                width: 500,
                height: 50,
                child: GooglePlaceAutoCompleteTextField(
                  textStyle: TextStyle(color: Colors.white),
                  boxDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  textEditingController: controller,
                  googleAPIKey: "AIzaSyAVmAwz26C4R61AE2vJfnT2uRif6CjepoY",
                  inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '¿A dónde quieres ir?'),
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
                    widget.irAMapa(1, searchedLoc, false, null, null, false,
                        null, prediction);
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  // if we want to make custom list item builder
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
                  }
                  // if you want to add seperator between list items
                  ,
                  seperatedBuilder: Divider(
                    height: 0,
                  ),
                  // want to show close icon
                  isCrossBtnShown: true,
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 78.0),
                  child: Center(
                    child: Image.asset(
                      'assets/images/parada.png',
                      height: 230,
                      width: 230,
                    ),
                  ),
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
