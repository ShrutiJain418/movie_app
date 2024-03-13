// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_rethrow_when_possible, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felix/main.dart';
import 'package:felix/pages/forgetPassword.dart';
import 'package:felix/pages/homepage.dart';
import 'package:felix/pages/signup.dart';
import 'package:felix/utils.dart';
import 'package:felix/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            IconButton(
              alignment: Alignment.topLeft,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LandingPage(),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Text(
                'FELIX',
                style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 80.0,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSaved: (email) {},
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.lock),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80.0),
            ElevatedButton(
              onPressed: () {
                //authentication
                login();

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => HomePage(),
                //   ),
                // );
              },
              child: Text(
                "Login".toUpperCase(),
              ),
            ),
            const SizedBox(height: 15.0),
            GestureDetector(
              child: Center(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15,
                  ),
                ),
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ForgetPasswordPage(),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Do not have an account?',
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          //start the collection when user login in successfully
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;
//if user is not null make a collection 'users' and get their uid
        if (user != null) {
          DocumentSnapshot userdoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          print(user.uid);
//set the email of the user for future reference and watchlist
          if (!userdoc.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({'email': user.email, 'Watchlist': []});
          }
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(
              currentIndex: 0,
            ),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(e.message);
    }
  }
}

class FireBaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWatching(String id, String status, String mediaType) async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('WatchList')) {
        List<dynamic> watchlist = userData['WatchList'];

        for (var i = 0; i < watchlist.length; i++) {
          if (watchlist[i]['Id'] == id) {
            await _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .update({
                  'WatchList': FieldValue.arrayRemove([
                    {
                      "Id": id,
                      "status": watchlist[i]["status"],
                      "mediaType": watchlist[i]["mediaType"],
                    }
                  ])
                })
                .then((value) {})
                .catchError((error) {});
          }
        }
      }

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
            "WatchList": FieldValue.arrayUnion([
              {
                "Id": id,
                "status": status,
                "mediaType": mediaType,
              }
            ])
          })
          .then((value) => {})
          .catchError((error) {});
    } catch (error) {
      throw error;
    }
  }

  Future<List<dynamic>> getWatchList() async {
    try {
      DocumentSnapshot userSnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('WatchList')) {
        List<dynamic> watchlist = userData['WatchList'];
        return watchlist;
      } else {
        return [];
      }
    } catch (error) {
      throw error;
    }
  }

  // Future<String> getPosterUrl(String id) async {
  //   try {
  //     DocumentSnapshot userSnapshot = await _firestore
  //         .collection('users')
  //         .doc(_auth.currentUser!.uid)
  //         .get();

  //     if (userSnapshot.exists && userSnapshot.data() != null) {
  //       Map<String, dynamic>? userData =
  //           userSnapshot.data() as Map<String, dynamic>?;

  //       if (userData != null && userData.containsKey('WatchList')) {
  //         List<dynamic> watchlist = userData['WatchList'];
  //         for (var movie in watchlist) {
  //           if (movie['Id'] == id) {
  //             return movie['poster_path'] ?? '';
  //           }
  //         }
  //       }
  //     }

  //     return '';
  //   } catch (error) {
  //     print('Error fetching poster URL: $error');
  //     return '';
  //   }
  // }
}
