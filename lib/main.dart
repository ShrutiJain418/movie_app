// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:felix/firebase_options.dart';
import 'package:felix/pages/homepage.dart';
import 'package:felix/pages/login.dart';
import 'package:felix/pages/signup.dart';
import 'package:felix/utils.dart';
import 'package:felix/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'FLIXIE',
      theme: ThemeData.dark(),
      home: FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(color: Colors.black);
          } else if (snapshot.data != null) {
            return HomePage();
          } else {
            return FutureBuilder<bool>(
              future: Utils.isFirstTimeOpening(),
              builder: (context, isFirstTimeSnapshot) {
                if (isFirstTimeSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Container(color: Colors.black);
                } else if (isFirstTimeSnapshot.hasError) {
                  return Scaffold(
                      body: Center(
                          child: Text('Error: ${isFirstTimeSnapshot.error}')));
                } else {
                  final isFirstTime = isFirstTimeSnapshot.data ?? true;
                  return isFirstTime
                      ? AnimatedSplashScreen(
                          backgroundColor: Colors.black,
                          duration: 3000,
                          splash: Text(
                            'FLIXIE',
                            style: GoogleFonts.rubikScribble(
                              textStyle: TextStyle(
                                fontSize: 60.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          nextScreen: LandingPage(),
                          splashTransition: SplashTransition.fadeTransition,
                        )
                      : LoginPage();
                }
              },
            );
          }
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FLIXIE',
                      style: GoogleFonts.caveat(
                        textStyle: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                Text(
                  'Welcome to\nFLIXIE',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.unna(
                    textStyle: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Watch everything you want\nfor free!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.eduNswActFoundation(
                    textStyle:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.w100),
                  ),
                ),
                SizedBox(height: 20.0),
                Image.asset(
                  'assets/images/Picture.png',
                  height: 300,
                  width: 300,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomNavBar(
                                currentIndex: 0,
                              )),
                    );
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[200], // Button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    elevation: 5, // Add shadow
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
