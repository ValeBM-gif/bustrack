import 'package:flutter/material.dart';

import '../constants.dart';

class InstruccionSeparator extends StatefulWidget {
  const InstruccionSeparator({super.key});

  @override
  State<InstruccionSeparator> createState() => _InstruccionSeparatorState();
}

class _InstruccionSeparatorState extends State<InstruccionSeparator> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 6,
              width: 3,
              decoration: BoxDecoration(color: kSecondaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 6,
              width: 3,
              decoration: BoxDecoration(color: kSecondaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              height: 6,
              width: 3,
              decoration: BoxDecoration(color: kSecondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
