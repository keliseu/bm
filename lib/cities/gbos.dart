import 'package:bm/main.dart';
import 'package:flutter/material.dart';

class gBosPage extends StatelessWidget {
  const gBosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("boston"),),
      body: Center(
        child: ElevatedButton(
          onPressed: () {  },
          child: const Text("Go To Home"),
        ),
      ),
    );
  }
}