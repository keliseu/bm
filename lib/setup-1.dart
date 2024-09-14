import 'package:bm/cities/gbos.dart';
import 'package:bm/main.dart';
import 'package:bm/setup-2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


class setupPage1 extends StatelessWidget {
  const setupPage1({super.key});

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
            ]
        )
    ),
      child: Scaffold(
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'bm',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontSize: 128,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ultimate transport',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'By using bm, you agree to our Terms of Service and Privacy Policy.',
          style: TextStyle(
              fontFamily: 'Ndot',
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 10,
            ),),
            const SizedBox(height: 10), // Add some space between the text and the button
            Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const setupPage2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff000),
                ),
                child: const Center(
                  child: Text(
                    'start',
                    style: TextStyle(
                      fontFamily: 'Ndot',
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      fontSize: 36,
                    ),
                  ),
                ),
              ),

            ),
          ],
        ),

    ),
    );

  }
}