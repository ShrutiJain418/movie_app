// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:felix/models/nowPlaying.dart';
import 'package:felix/models/topratedseries.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/utils.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String end;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    end = "movie/upcoming";
    final url = "$baseUrl$end$key";

    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $apiKey'});

    if (response.statusCode == 200) {
      log("success");
      log(response.body);
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    end = "movie/now_playing";
    final url = "$baseUrl$end$key";

    final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $apiKey'});

    log('xcewfewf');
    if (response.statusCode == 200) {
      log("success1");
      log(response.body);
      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed");
  }

  Future<TopRatedSeriesModel> getTopRatedSeries() async {
    end = "movie/top_rated";
    final url = "$baseUrl$end$key";

    final response = await http.get(
      Uri.parse(url),
      //headers: {HttpHeaders.authorizationHeader: 'Bearer $apiKey'}
    );

    if (response.statusCode == 200) {
      log("success");
      log(response.body);
      return TopRatedSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch top rated series");
  }
}
