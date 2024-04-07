import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const imageUrl = "http://image.tmdb.org/t/p/w500";

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static const _keyFirstTime = 'first_time';

  static Future<bool> isFirstTimeOpening() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool(_keyFirstTime) ?? true;
    if (isFirstTime) {
      await prefs.setBool(_keyFirstTime, false);
    }
    return isFirstTime;
  }
}
