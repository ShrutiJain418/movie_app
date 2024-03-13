// ignore_for_file: prefer_const_constructors

import 'package:felix/pages/login.dart';
import 'package:felix/services/api_services.dart';
import 'package:felix/utils.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
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

class WatchlistItem extends StatefulWidget {
  final int movieId;
  final String status;
  final FireBaseServices fireBaseServices;

  const WatchlistItem({
    required this.movieId,
    required this.status,
    required this.fireBaseServices,
    Key? key,
  }) : super(key: key);

  @override
  _WatchlistItemState createState() => _WatchlistItemState();
}

class _WatchlistItemState extends State<WatchlistItem> {
  late Future<String> _posterUrlFuture;

  @override
  void initState() {
    super.initState();
    _posterUrlFuture = getPosterUrl(widget.movieId);
  }

  Future<String> getPosterUrl(int movieId) async {
    try {
      var details = await ApiServices().getDescription(movieId);
      return '$imageUrl${details.posterPath}';
    } catch (error) {
      print('Error fetching poster URL: $error');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _posterUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String posterUrl = snapshot.data ?? '';
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
                      image: NetworkImage(posterUrl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Movie ID: ${widget.movieId}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Status: ${widget.status}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey),
                      ),
                    ],
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
