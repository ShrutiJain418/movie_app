// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:felix/models/description.dart';
import 'package:felix/pages/login.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  FireBaseServices fireBaseServices = FireBaseServices();
  late Future<List<dynamic>> _watchlistFuture;

  @override
  void initState() {
    super.initState();
    _watchlistFuture = fireBaseServices.getWatchList();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('Watchlist'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please log in to view your watchlist!!!',
                style: GoogleFonts.unna(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Watchlist'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _watchlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<dynamic>? watchlist = snapshot.data;
            if (watchlist != null && watchlist.isNotEmpty) {
              return ListView.builder(
                itemCount: watchlist.length,
                itemBuilder: (context, index) {
                  return WatchlistItem(
                    movieId: int.parse(watchlist[index]['Id']),
                    status: watchlist[index]['status'],
                    fireBaseServices: fireBaseServices,
                    onRemove: () {
                      // Remove the movie from the watchlist
                      setState(() {
                        watchlist.removeAt(index);
                      });
                    },
                  );
                },
              );
            } else {
              return Center(child: Text('Watchlist is empty'));
            }
          }
        },
      ),
    );
  }
}

// class WatchlistItem extends StatefulWidget {
//   final int movieId;
//   final String status;
//   final FireBaseServices fireBaseServices;

//   const WatchlistItem({
//     required this.movieId,
//     required this.status,
//     required this.fireBaseServices,
//     Key? key,
//   }) : super(key: key);

//   @override
//   _WatchlistItemState createState() => _WatchlistItemState();
// }

// class _WatchlistItemState extends State<WatchlistItem> {
//   late Future<String> _posterUrlFuture;

//   @override
//   void initState() {
//     super.initState();
//     _posterUrlFuture = getPosterUrl(widget.movieId);
//   }

//   Future<String> getPosterUrl(int movieId) async {
//     try {
//       var details = await ApiServices().getDescription(movieId);
//       return '$imageUrl${details.posterPath}';
//     } catch (error) {
//       print('Error fetching poster URL: $error');
//       return '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//       future: _posterUrlFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           String posterUrl = snapshot.data ?? '';
//           return Container(
//             margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             decoration: BoxDecoration(
//               color: Colors.grey[400],
//               borderRadius: BorderRadius.circular(12),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 5,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 200,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(posterUrl),
//                       fit: BoxFit.cover,
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(12),
//                       bottomLeft: Radius.circular(12),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Movie ID: ${widget.movieId}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'Status: ${widget.status}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600, color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }
class WatchlistItem extends StatefulWidget {
  final int movieId;
  final String status;
  final FireBaseServices fireBaseServices;
  final VoidCallback onRemove;

  const WatchlistItem({
    required this.movieId,
    required this.status,
    required this.fireBaseServices,
    Key? key,
    required this.onRemove,
  }) : super(key: key);

  @override
  _WatchlistItemState createState() => _WatchlistItemState();
}

class _WatchlistItemState extends State<WatchlistItem> {
  late Future<DescriptionModel> _movieDescriptionFuture;

  @override
  void initState() {
    super.initState();
    _movieDescriptionFuture = _fetchMovieDescription();
  }

  Future<DescriptionModel> _fetchMovieDescription() async {
    try {
      ApiServices apiServices = ApiServices();
      return await apiServices.getDescription(widget.movieId);
    } catch (error) {
      print('Error fetching movie description: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DescriptionModel>(
      future: _movieDescriptionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          DescriptionModel movieDescription = snapshot.data!;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '$imageUrl${movieDescription.posterPath}'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          movieDescription.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.neuton(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          movieDescription.overview,
                          style: GoogleFonts.philosopher(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54,
                                  fontSize: 12)),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Status: ${widget.status}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
