// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:felix/firebase_options.dart';
import 'package:felix/pages/homepage.dart';
import 'package:felix/pages/signup.dart';
import 'package:felix/utils.dart';
import 'package:felix/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'FLIXIE',
      theme: ThemeData.dark(),
      home: AnimatedSplashScreen(
        backgroundColor: Colors.black,
        duration: 3000,
        splash: Text(
          'FLIXIE',
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        nextScreen: LandingPage(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FLIXIE',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
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
                        fontSize: 15.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 70.0),
              Flexible(
                flex: 1,
                child: Text(
                  'Welcome to FLIXIE',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20.0),
              Flexible(
                flex: 1,
                child: Text(
                  'Watch everything you want\n for free!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(height: 50.0),
              Flexible(
                flex: 2,
                child: Image.asset(
                  'assets/images/Picture2.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 80.0),
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
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
