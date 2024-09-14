import 'package:flutter/material.dart';
import 'package:bm/screen/boston.dart';

class WelcomeBoston extends StatefulWidget {
  const WelcomeBoston({Key? key}) : super(key: key);

  @override
  _WelcomeBostonState createState() => _WelcomeBostonState();
}

class _WelcomeBostonState extends State<WelcomeBoston> {
  @override
  void initState() {
    super.initState();
    // Set up the delayed navigation
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => bostonMAPAPP()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Colors.white,
            Color(0xFFF8F8F8),
            Color(0xFFF0F0F0),
            Color(0xFFE8E8E8),
            Color(0xFFE0E0E0),
            Color(0xFFD8D8D8),
            Color(0xFFD0D0D0),
            Color(0xFFC8C8C8),
          ],
        ),
      ),
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome to Boston',
              style: const TextStyle(
                fontSize: 48,
                fontFamily: 'Ndot',
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }}