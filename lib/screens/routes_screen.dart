import 'package:bustrackk/widgets/rutas_list_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:google_places_flutter/model/prediction.dart';

import '../constants.dart';
import '../models/ruta.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              IntrinsicHeight(
                child: Container(
                  width: double.infinity,
                  color: Colors.black54,
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Rutas Disponibles',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              const Expanded(
                  child: RutasListView(
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
