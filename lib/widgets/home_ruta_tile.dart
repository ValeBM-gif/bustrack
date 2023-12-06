import 'package:bustrackk/main.dart';
import 'package:bustrackk/models/parada.dart';
import 'package:bustrackk/screens/map_screen.dart';
import 'package:bustrackk/widgets/rutas_list_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../constants.dart';
import '../models/ruta.dart';

class HomeRutaTile extends StatefulWidget {
  final LatLng coordenadasDestino;
  final Prediction prediction;
  final Ruta ruta;
  const HomeRutaTile({super.key, required this.ruta, required this.prediction, required this.coordenadasDestino});

  @override
  State<HomeRutaTile> createState() => _HomeRutaTileState();
}

class _HomeRutaTileState extends State<HomeRutaTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MapScreen(
                posicionCamara: LatLng((userLocation!.latitude+widget.coordenadasDestino.latitude)/2,(userLocation!.longitude+widget.coordenadasDestino.longitude)/2),
                ruta: widget.ruta,
                prediction: widget.prediction,
                deDondeProviene: 2,
                //todo: personalizar paradas con base a ruta
                paradas: paradas,
              );
            },
          ),
        );
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colorScaffold,
          border: Border.all(
              color: kPrimaryColor,
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_bus,
                  color: kIconsColor,
                ),
                Container(
                  color: getIconColor(
                    widget.ruta.tipo!,
                    widget.ruta.nombre!,
                  ),
                  height: 3,
                  width: 20,
                )
              ],
            ),
            SizedBox(
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.ruta.nombre!,
                    style: const TextStyle(color: kIconsColor),
                  ),
                  Text(
                    rutas[0].direccion,
                    style: const TextStyle(color: kIconsColor),
                  ),
                ],
              ),
            ),
            Text(
              '${widget.ruta.nombre!='L2'?calcularTiempoLlegadaDestino():18} mins',
              style: const TextStyle(color: kIconsColor),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }
}
