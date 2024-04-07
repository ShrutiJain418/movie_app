// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, dead_code, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felix/models/description.dart';
import 'package:felix/models/recommendation.dart';
import 'package:felix/pages/historyPage.dart';
import 'package:felix/pages/homepage.dart';
import 'package:felix/pages/login.dart';
import 'package:felix/pages/searchPage.dart';
import 'package:felix/pages/videoplayer.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/services/extraservices.dart';
import 'package:felix/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key, required this.movieId});

  final int movieId;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  ApiServices apiServices = ApiServices();
  late Future<DescriptionModel> moviedescription;
  late Future<RecommendationModel> movierecommendation;
  late Future<String> trailerUrlFuture;

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() {
    moviedescription = apiServices.getDescription(widget.movieId);
    movierecommendation = apiServices.getRecommendedMovies(widget.movieId);
    trailerUrlFuture = Future.value(apiServices.getTrailerUrl(widget.movieId));

    setState(() {});
  }

  final FireBaseServices _firebaseServices = FireBaseServices();

  Future<void> _addToWatchlist() async {
    try {
      String status = 'Watch Later';
      String mediaType = 'Movie';

      await _firebaseServices.addWatching(
        widget.movieId.toString(),
        status,
        mediaType,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to watchlist'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add movie to watchlist: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: moviedescription,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final movie = snapshot.data;
              final movieGenre = movie!.genres
                  .map(
                    (genre) => genre.name,
                  )
                  .join(", ");
              return Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                NetworkImage("$imageUrl${movie!.posterPath}"),
                          ),
                        ),
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                alignment: Alignment.topLeft,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                  );
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VideoPlayerPage(
                                            videoUrl:
                                                'https://www.youtube.com/watch?v=U2Qp5pL3ovA',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.play_circle,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      _addToWatchlist();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryPage(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  // Visibility(
                                  //   visible: movie.adult,
                                  //   child: ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       shape: CircleBorder(),
                                  //     ),
                                  //     onPressed: () {},
                                  //     child: Icon(
                                  //       Icons.warning,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: GoogleFonts.neuton(
                            textStyle: TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              'Genre: ${movieGenre.split(',').take(3).toList().join(", ")}...',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          movie.overview,
                          style: GoogleFonts.philosopher(
                            textStyle: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FutureBuilder(
                    future: movierecommendation,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final movierecom = snapshot.data;
                      return movierecom!.results.isEmpty
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    'More Like This...',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                GridView.builder(
                                  itemCount: movierecom.results.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 1.5 / 2,
                                  ),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DescriptionPage(
                                              movieId:
                                                  movierecom.results[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              "$imageUrl${movierecom.results[index].posterPath}"),
                                    );
                                  },
                                ),
                              ],
                            );
                    },
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('{$snapshot.error}');
            } else {
              return Text('error');
            }
          },
        ),
      ),
    );
  }
}
