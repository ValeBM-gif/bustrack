import 'package:bustrackk/models/lugar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../main.dart';
import '../screens/map_screen.dart';

class ListaBusquedasRecientes extends StatefulWidget {
  const ListaBusquedasRecientes({super.key});

  @override
  State<ListaBusquedasRecientes> createState() =>
      _ListaBusquedasRecientesState();
}

class _ListaBusquedasRecientesState extends State<ListaBusquedasRecientes> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: lugaresBuscadosRecientemente.length,
        itemBuilder: (BuildContext context, int index) {
          var lugar = lugaresBuscadosRecientemente[index];
          return Column(
            children: [
              GestureDetector(
                onTap: (){},
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.place,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lugar.nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.height * .25,
                              child: Text(
                                lugar.direccion,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 35,),
                            Text(
                              '${lugar.distanciaDesdeOrigen} km',
                              style: const TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        });
  }
}
