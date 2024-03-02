import 'package:flutter/material.dart';

const apiKey = "f78acc01e56b3994efa2559dbbd80c80";
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
}
