import 'package:flutter/material.dart';

import '../constants.dart';

class CustomizedCard2 extends StatefulWidget {
  final textoPrincipal;
  final textoSecundario;
  final Color fondo;
  final Color? sombra;
  final imagenPath;
  //final Icon icono;
  // final texto;
  const CustomizedCard2(
      {super.key,
      required this.textoPrincipal,
      required this.fondo,
      required this.sombra,
      required this.textoSecundario,
      required this.imagenPath});

  @override
  State<CustomizedCard2> createState() => _CustomizedCard2State();
}

class _CustomizedCard2State extends State<CustomizedCard2> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      color: widget.fondo,
      shadowColor: widget.sombra,
      child: GestureDetector(
        onTap: () {
          print('picade');
        },
        child: SizedBox(
          width: 330,
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Image.asset(
                      widget.imagenPath,
                      height: 100,
                      width: 100,
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.textoPrincipal,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade800
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.textoSecundario,
                          maxLines: 2,
                          style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
