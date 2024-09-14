import 'package:bm/screen/welcome/welcomeboston.dart';
import 'package:flutter/material.dart';

class LoadingBos extends StatefulWidget {
  const LoadingBos({Key? key}) : super(key: key);

  @override
  _LoadingBosState createState() => _LoadingBosState();
}

class _LoadingBosState extends State<LoadingBos> {
  @override
  void initState() {
    super.initState();
    // Set up the delayed navigation
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => WelcomeBoston()),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Loading city...',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Ndot',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20), // Add some space between text and indicator
            const CircularProgressIndicator(), // Add the circular progress indicator
          ],
        ),
      ),
    ),
    );
  }
}