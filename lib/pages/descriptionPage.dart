// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, dead_code, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felix/models/description.dart';
import 'package:felix/models/recommendation.dart';
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

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  fetchdata() {
    moviedescription = apiServices.getDescription(widget.movieId);
    movierecommendation = apiServices.getRecommendedMovies(widget.movieId);

    setState(() {});
  }

  // addToHistoryPage function
  // void addToHistoryPage() async {
  //   try {
  //     var userId = FirebaseAuth.instance.currentUser?.uid;
  //     if (userId != null) {
  //       var snapshot = await FirebaseFirestore.instance
  //           .collection('history')
  //           .doc(userId)
  //           .get();

  //       if (snapshot.exists) {
  //         var movies = snapshot.data()?['movies'] as List<dynamic>?;

  //         if (movies != null) {
  //           await FirebaseFirestore.instance
  //               .collection('history')
  //               .doc(userId)
  //               .update({
  //             'movies': FieldValue.arrayUnion([widget.movieId])
  //           });
  //         } else {
  //           // Create 'movies' field if it doesn't exist
  //           await FirebaseFirestore.instance
  //               .collection('history')
  //               .doc(userId)
  //               .set({
  //             'movies': [widget.movieId]
  //           });
  //         }
  //       } else {
  //         // Create new document if it doesn't exist
  //         await FirebaseFirestore.instance
  //             .collection('history')
  //             .doc(userId)
  //             .set({
  //           'movies': [widget.movieId]
  //         });
  //       }
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Movie added to history page'),
  //         ),
  //       );
  //     } else {
  //       // Handle case where user is not authenticated
  //       throw 'User is not authenticated';
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to add movie to history page: $error'),
  //       ),
  //     );
  //   }
  // }
  final FireBaseServices _firebaseServices = FireBaseServices();

  // Method to add the current movie to the user's watchlist
  Future<void> _addToWatchlist() async {
    try {
      // Replace these values with actual status and media type
      String status = 'Watch Later';
      String mediaType = 'Movie';

      // Call the addWatching method to add the movie to the watchlist
      await _firebaseServices.addWatching(
        widget.movieId.toString(), // Pass the movie ID
        status,
        mediaType,
      );

      // Show a success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Movie added to watchlist'),
        ),
      );
    } catch (error) {
      // Show an error message if adding to watchlist fails
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
            if (snapshot.hasData) {
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
                                        builder: (context) => SearchPage()),
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
                                                'https://www.youtube.com/watch?v=nC1rbW2YSz0&list=PL9gnSGHSqcnp39cTyB1dTZ2pJ04Xmdrod&index=11', // Pass your video URL here
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.play_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      // pshowDialog(context,
                                      //     widget.movieId.toString(), "movie");
                                      _addToWatchlist();
                                    },
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Visibility(
                                    visible: movie.adult,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.warning,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              movieGenre,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          movie.overview,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  FutureBuilder(
                    future: movierecommendation,
                    builder: (context, snapshot) {
                      final movierecom = snapshot.data;
                      return movierecom!.results.isEmpty
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'More Like This',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  height: 20.0,
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
