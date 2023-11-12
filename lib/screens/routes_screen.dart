import 'package:bustrackk/widgets/rutas_list_view.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoutesScreen extends StatefulWidget {
  final irAMapa;
  const RoutesScreen({super.key,required this.irAMapa});

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
              Expanded(
                  child: RutasListView(
                irAMapa: widget.irAMapa,
                setRutaActual: () {},
              )),
            ],
          ),
        ),
      ),
    );
  }
}
