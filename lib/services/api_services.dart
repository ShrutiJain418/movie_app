// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:felix/models/description.dart';
import 'package:felix/models/nowPlaying.dart';
import 'package:felix/models/recommendation.dart';
import 'package:felix/models/search.dart';
import 'package:felix/models/topratedseries.dart';
import 'package:felix/models/topsearches.dart';
import 'package:felix/models/upcomingMovies.dart';
import 'package:felix/models/video.dart';
import 'package:felix/models/watchlistmodel.dart';
import 'package:felix/utils.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=${dotenv.env['apiKey']}";
late String end;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    end = "movie/upcoming";
    final url = "$baseUrl$end$key";

    final response = await http.get(
      Uri.parse(url),
    );

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

    final response = await http.get(
      Uri.parse(url),
    );

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
    print(url);

    if (response.statusCode == 200) {
      log("success");
      log(response.body);
      return TopRatedSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch top rated series");
  }

  Future<SearchModel> getSearchedMovies(String searchedText) async {
    end = "search/movie?query=$searchedText";
    final url = "$baseUrl$end";

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzhhY2MwMWU1NmIzOTk0ZWZhMjU1OWRiYmQ4MGM4MCIsInN1YiI6IjY1ZDk5NzdlZmNiOGNjMDE2MmNhZTZmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.idQSIX7j2vWhx44azzUiZXUmTZgXhBIOPbIa0AVp3l8'
    });

    if (response.statusCode == 200) {
      log("success");
      log(response.body);
      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch searched movie");
  }

  Future<TopSearchesModel> getTopSearchedMovies() async {
    end = "movie/popular";
    final url = "$baseUrl$end$key";

    final response = await http.get(
      Uri.parse(url),
      //headers: {HttpHeaders.authorizationHeader: 'Bearer $apiKey'}
    );

    if (response.statusCode == 200) {
      log("successful");
      log(response.body);
      return TopSearchesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch popular movies");
  }

  Future<DescriptionModel> getDescription(int movieId) async {
    end = "movie/$movieId";
    final url = "$baseUrl$end$key";

    final response = await http.get(
      Uri.parse(url),
      //headers: {HttpHeaders.authorizationHeader: 'Bearer $apiKey'}
    );

    if (response.statusCode == 200) {
      log("success description");
      log(response.body);
      return DescriptionModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch movie description");
  }

  Future<RecommendationModel> getRecommendedMovies(int movieId) async {
    end = "movie/$movieId/recommendations";
    final url = "$baseUrl$end";

    final response = await http.get(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader:
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzhhY2MwMWU1NmIzOTk0ZWZhMjU1OWRiYmQ4MGM4MCIsInN1YiI6IjY1ZDk5NzdlZmNiOGNjMDE2MmNhZTZmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.idQSIX7j2vWhx44azzUiZXUmTZgXhBIOPbIa0AVp3l8'

      // 'Authorization':
      //     'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzhhY2MwMWU1NmIzOTk0ZWZhMjU1OWRiYmQ4MGM4MCIsInN1YiI6IjY1ZDk5NzdlZmNiOGNjMDE2MmNhZTZmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.idQSIX7j2vWhx44azzUiZXUmTZgXhBIOPbIa0AVp3l8'
    });

    if (response.statusCode == 200) {
      log("success");
      log(response.body);
      return RecommendationModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to fetch recommended movies");
  }

  Future<VideoModel> fetchVideos(String movieId, String mediaType) async {
    try {
      final url = '$baseUrl/$mediaType/$movieId/videos?$key';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return VideoModel.fromJson(responseData);
      } else {
        throw Exception('Failed to fetch videos: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch videos: $error');
    }
  }

  Future<void> addToWatchlist(String accountId, int movieId) async {
    end = "account/$accountId/watchlist";

    final url = '$baseUrl$end$key';

    final Map<String, dynamic> requestBody = {
      'media_type': 'movie',
      'media_id': movieId,
      'watchlist': true,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Movie added to watchlist successfully');
      } else {
        print('Failed to add movie to watchlist: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error adding movie to watchlist: $e');
    }
  }

  Future<List<Movie>> fetchWatchlistMovies(String accountId) async {
    try {
      end = "account/$accountId/watchlist/movies";
      final String url = '$baseUrl$end$key';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJmNzhhY2MwMWU1NmIzOTk0ZWZhMjU1OWRiYmQ4MGM4MCIsInN1YiI6IjY1ZDk5NzdlZmNiOGNjMDE2MmNhZTZmOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.idQSIX7j2vWhx44azzUiZXUmTZgXhBIOPbIa0AVp3l8'
        },
      );

      if (response.statusCode == 200) {
        log("successfully fetched watchlisted movies");
        log(response.body);

        final Map<String, dynamic> responseData = json.decode(response.body);
        final Movie movie = Movie.fromJson(responseData);

        return [movie];
      } else {
        throw Exception(
            'Failed to fetch watchlist movies: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch watchlisted movies: $error');
    }
  }

  String getTrailerUrl(int movieId) {
    return 'https://www.youtube.com/trailer?id=$movieId';
  }
}
