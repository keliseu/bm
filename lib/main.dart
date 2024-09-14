import 'package:bm/screen/auckland.dart';
import 'package:bm/setup-1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/boston.dart';
import 'screen/nyc.dart';

import 'cityChoosingSetup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  // make navigation bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent
    ),
  );


  // make flutter draw behind navigation bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(MyApp());



  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
         primaryColor: Colors.blue,
         hintColor: Colors.blueAccent,
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Set button color explicitly
        ),

      ),
      home: FutureBuilder<bool>(
        future: FirstTimeSetup.isSetupComplete(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            final bool setupComplete = snapshot.data ?? false;
            if (!setupComplete) {
              return const setupPage1();
            } else {
              return FutureBuilder<String?>(
                future: FirstTimeSetup.getChosenOption(),
                builder: (context, optionSnapshot) {
                  if (optionSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    final String? chosenCity = optionSnapshot.data;
                    switch (chosenCity) {
                      case 'Boston':
                        return bostonMAPAPP();
                      case 'New York City':
                        return nycMAPAPP();
                      case 'Auckland':
                        return aucklandMAPAPP();
                      default:
                      // Handle unexpected cases or show an error
                        return const setupPage1();
                    }
                  }
                },
              );
            }
          }
        },
      ),
    );
  }
}
