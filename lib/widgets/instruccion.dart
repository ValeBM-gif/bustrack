import 'package:flutter/material.dart';

import '../constants.dart';

class Instruccion extends StatefulWidget {
  final tiempo;
  final texto;
  final IconData icono;
  const Instruccion({super.key,required this.tiempo,required this.texto,required this.icono});

  @override
  State<Instruccion> createState() => _InstruccionState();
}

class _InstruccionState extends State<Instruccion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(color: kSecondaryColor, border: Border.all(),borderRadius: BorderRadius.circular(9),),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(widget.icono, color: Colors.grey.shade900,),
              const SizedBox(width: 3,),
              Text(
                widget.texto,
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey.shade900),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0),
                child: Container(
                  height: 23,
                  width: 3,
                  color: Colors.grey.shade900,
                ),
              ),
              Text(
                widget.tiempo,
                style:  TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey.shade900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
