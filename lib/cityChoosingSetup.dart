import 'package:bm/screen/auckland.dart';
import 'package:bm/screen/boston.dart';
import 'package:bm/screen/nyc.dart';
import 'package:bm/screen/philly.dart';
import 'package:bm/screen/welcome/loadingpageboston.dart';
import 'package:flutter/material.dart';
import 'package:bm/main.dart';
import 'package:bm/setup-2.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Add this class at the top of your file
class FirstTimeSetup {
  static const String _setupCompleteKey = 'setup_complete';
  static const String _chosenOptionKey = 'chosen_option';

  static Future<bool> isSetupComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_setupCompleteKey) ?? false;
  }

  static Future<void> setSetupComplete(String chosenOption) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_setupCompleteKey, true);
    await prefs.setString(_chosenOptionKey, chosenOption);
  }

  static Future<String?> getChosenOption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chosenOptionKey);
  }
}

class cityChoosingSetup extends StatelessWidget {
  const cityChoosingSetup({Key? key}) : super(key: key);

  void _completeSetup(BuildContext context, String city) async {
    await FirstTimeSetup.setSetupComplete(city);

    // Navigate to the appropriate screen based on the chosen city
    switch (city) {
      case 'Boston':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoadingBos()),
        );
        break;
      case 'New York City':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => nycMAPAPP()),
        );
        break;
      case 'Auckland':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => aucklandMAPAPP()),
        );
        break;
      default:
      // Handle unexpected cases or show an error
        break;
    }
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
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Select your city',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                bostonCard(context, onSelect: () => _completeSetup(context, 'Boston')),
                const SizedBox(height: 20),
                nycCard(context, onSelect: () => _completeSetup(context, 'New York City')),
                const SizedBox(height: 20),
                aucklandCard(context, onSelect: () => _completeSetup(context, 'Auckland')),
                const SizedBox(height: 40),
                requestCard(context),
                const SizedBox(height: 60)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// Modify your existing card widgets to accept an onSelect callback
Widget bostonCard(BuildContext context, {required VoidCallback onSelect}) {
  return Center(
    child: SizedBox(
      width: 350,
      height: 250,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 16), // Add some space between title and subtitle
                    Text(
                      'You can always change your city later.',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                content: const SizedBox(
                  width: 300,
                  height: 10,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Nope'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelect();
                    },
                  ),
                ],
              );
            },
          );
        },

        child: Card(
          margin: EdgeInsets.zero,
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Stack(
            children: [
              // Background image with color overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.5)],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.lighten,
                  child: Image.asset(
                    'assets/images/boston.png', // Replace with your image path
                    fit: BoxFit.cover,
                    width: 350,
                    height: 250,
                  ),
                ),
              ),

             /* const Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 0.0, color: Colors.white),
                  ),
                ),
              ),*/

              const Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Text(
                  'Boston',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget nycCard(BuildContext context, {required VoidCallback onSelect}) {
  return Center(
    child: SizedBox(
      width: 350,
      height: 250,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 16), // Add some space between title and subtitle
                    Text(
                      'You can always change your city later.',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                content: const SizedBox(
                  width: 300,
                  height: 10,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Nope'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelect();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: const Color(0xff000),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'COMING SOON...',
                    style: TextStyle(fontSize: 34.0, color: Colors.white, fontFamily: 'Ndot'),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.5)],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.lighten,
                  child: Image.asset(
                    'assets/images/nyc.png', // Replace with your image path
                    fit: BoxFit.cover,
                    width: 350,
                    height: 250,
                  ),
                ),
              ),
              const Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Text(
                  'New York City',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget aucklandCard(BuildContext context, {required VoidCallback onSelect}) {
  return Center(
    child: SizedBox(
      width: 350,
      height: 250,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 16), // Add some space between title and subtitle
                    Text(
                      'You can always change your city later.',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                content: const SizedBox(
                  width: 300,
                  height: 10,
                ),

                actions: <Widget>[
                  TextButton(
                    child: const Text('Nope'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onSelect();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: const Color(0xff000),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Stack(
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.5)],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.lighten,
                  child: Image.asset(
                    'assets/images/auck.png', // Replace with your image path
                    fit: BoxFit.cover,
                    width: 350,
                    height: 250,
                  ),
                ),
              ),


              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'COMING SOON...',
                    style: TextStyle(fontSize: 34.0, color: Colors.white, fontFamily: 'Ndot'),
                  ),
                ),
              ),
              const Positioned(
                right: 20.0,
                bottom: 20.0,
                child: Text(
                  'Auckland',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget requestCard(BuildContext context) {
  return Center(
    child: SizedBox(
      width: 350,
      height: 50,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you sure?',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(height: 16), // Add some space between title and subtitle
                    Text(
                      'You can always change your city later.',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                content: const SizedBox(
                  width: 300,
                  height: 10,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Nope',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text(
                      'Yes',
                      style: TextStyle(
                        fontFamily: 'Ndot',
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    onPressed: () {
                      // Add your logic for the "Yes" button here
                      Navigator.of(context).pop(true); // Return true when "Yes" is pressed
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: const Color(0xff000),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                right: 85.0,
                bottom: 8.0,
                child: Text(
                  'Request a city!',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 26,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
