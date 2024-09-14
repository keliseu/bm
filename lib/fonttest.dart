import 'package:flutter/material.dart';

class FontTest1 extends StatelessWidget {
  const FontTest1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Normal Nfont',
          style: TextStyle(
            fontFamily: 'Ndot',
            fontSize: 48,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}