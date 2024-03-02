// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felix/models/nowPlaying.dart';
import 'package:felix/models/topratedseries.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/widgets/carousel.dart';
import 'package:felix/widgets/upcomingmovieWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'FELIX',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 32.0,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
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
            // FutureBuilder(
            //   future: topRatedSeries,
            //   builder: (context, snapshot) {
            //     switch (snapshot.connectionState) {
            //       case ConnectionState.none:
            //         return Text('Press button to start.');
            //       case ConnectionState.active:
            //       case ConnectionState.waiting:
            //         return Text('Awaiting result...');
            //       case ConnectionState.done:
            //         if (snapshot.hasError)
            //           return Text('Error: ${snapshot.error}');
            //         return CustomCarouselSlider(data: snapshot.data!);
            //       // You can reach your snapshot.data['url'] in here
            //     }
            //   },
            // ),
            FutureBuilder(
                future: topRatedSeries,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
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
    );
  }
}
