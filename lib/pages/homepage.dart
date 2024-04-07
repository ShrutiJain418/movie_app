// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felix/models/nowPlaying.dart';
import 'package:felix/models/topratedseries.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/pages/searchPage.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/widgets/carousel.dart';
import 'package:felix/widgets/upcomingmovieWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import '../models/upcomingMovies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UpcomingMovieModel> upcomingMovies;
  late Future<UpcomingMovieModel> nowPlaying;
  late Future<TopRatedSeriesModel> topRatedSeries;

  ApiServices apiServices = ApiServices();

  @override
  void initState() {
    upcomingMovies = apiServices.getUpcomingMovies();
    nowPlaying = apiServices.getNowPlayingMovies();
    topRatedSeries = apiServices.getTopRatedSeries();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Center(
            child: Text('FLIXIE',
                style: GoogleFonts.caveat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 28.0,
                  ),
                )),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: topRatedSeries,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData) {
                      return CustomCarouselSlider(data: snapshot.data!);
                    } else if (snapshot.hasError) {
                      return Text('{$snapshot.error}');
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
              MovieCard(future: nowPlaying, headline: "Now Playing"),
              MovieCard(future: upcomingMovies, headline: "Upcoming Movies"),
            ],
          ),
        ),
      ),
    );
  }
}
