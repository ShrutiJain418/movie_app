// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    super.key,
    required this.future,
    required this.headline,
  });

  final Future<UpcomingMovieModel> future;
  final String headline;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data?.results;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    headline,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: Image.network(
                          "$imageUrl${data[index].posterPath}",
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('{$snapshot.error}');
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
