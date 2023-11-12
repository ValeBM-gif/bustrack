import 'package:flutter/material.dart';

import '../constants.dart';

class CustomizedCard1 extends StatefulWidget {
   final titulo;
  final Color fondo;
   final Color? sombra;
   //final Icon icono;
  // final texto;
  const CustomizedCard1({super.key,required this.titulo, required this.fondo, required this.sombra,});

  @override
  State<CustomizedCard1> createState() => _CustomizedCard1State();
}

class _CustomizedCard1State extends State<CustomizedCard1> {
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
      child: InkWell(
        splashColor: kPrimaryColor.withAlpha(30),
        onTap: (){print('picade');},
        child: SizedBox(
          height: 96,
          width: 330,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.titulo,
                    style: kTextStyleTitles.copyWith(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        letterSpacing: .5),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 1.5,
                    color: kPrimaryColor,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_transit,
                        color: Colors.grey.shade700,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          'Calle shalala, en shalalal wndcdhb jshdjshduwh 522',
                          maxLines: 2,
                          style: TextStyle(color: Colors.grey.shade700),
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
