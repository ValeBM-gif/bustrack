import 'dart:math';

import 'package:bustrackk/constants.dart';
import 'package:bustrackk/main.dart';
import 'package:bustrackk/models/ruta.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_places_flutter/model/prediction.dart';

class RutasListView extends StatefulWidget {
  final void Function(int, maps.LatLng?, bool, maps.LatLng?, maps.LatLng?, bool, Ruta?, Prediction?) irAMapa;
  final Function setRutaActual;
  const RutasListView({super.key, required this.irAMapa, required this.setRutaActual});

  @override
  State<RutasListView> createState() => _RutasListViewState();
}

class _RutasListViewState extends State<RutasListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rutas.length,
      itemBuilder: (BuildContext context, int index) {
        final ruta = rutas[index];
        return Column(
          children: [
            Hero(
              tag: 'rutaTile',
              child: ListTile(
                onTap: (){
                  print('que ruta hay? ${ruta.nombre}');
                  widget.irAMapa(1, null, false, ruta.posicion1, ruta.posicion2, true, ruta, null);
                  widget.setRutaActual(ruta);
                },
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.directions_bus,
                    ),
                    Container(
                      color: getIconColor(ruta.tipo!, ruta.nombre!,),
                      height: 3,
                      width: 20,
                    )
                  ],
                ),
                title: Text(ruta.nombre!),
                subtitle: Text(ruta.direccion),
                trailing: Text(
                  '${calcularTiempoLlegadaDestino()} mins',
                  style: const TextStyle(color: Colors.transparent),
                ),
                style: ListTileStyle.drawer,
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }
}

Color getIconColor(TipoDeRuta tipoDeRuta, String nombreDeRuta) {
  switch (tipoDeRuta) {
    case TipoDeRuta.troncal:
      return getIconColorTroncal(nombreDeRuta);
    case TipoDeRuta.convencional:
      return Colors.red;
    case TipoDeRuta.auxiliar:
      return Colors.blueAccent;
    case TipoDeRuta.alimentadora:
      return Colors.yellow;
  }
  return Colors.white;
}

Color getIconColorTroncal(String rutaTroncal) {
  switch (rutaTroncal) {
    case 'L1':
      return Colors.lightBlue;
    case 'L2':
      return Colors.yellow.shade600;
    case 'L3':
      return Colors.red.shade700;
    case 'L4':
      return Colors.orange;
    case 'L5':
      return Colors.black54;
    case 'L6':
      return Colors.green.shade600;
    case 'L7':
      return Colors.purple.shade300;
    case 'L8':
      return Colors.greenAccent.shade200;
    case 'L9':
      return Colors.pinkAccent.shade100;
    case 'L10':
      return Colors.brown;
  }
  return Colors.white;
}

int calcularTiempoLlegadaDestino() {
  Random random = Random();
  return random.nextInt(60);
}
