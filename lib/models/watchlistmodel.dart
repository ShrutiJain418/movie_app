import 'dart:convert';

class Movie {
  int page;
  List<dynamic> results;
  int totalPages;
  int totalResults;

  Movie({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  Movie copyWith({
    int? page,
    List<dynamic>? results,
    int? totalPages,
    int? totalResults,
  }) =>
      Movie(
        page: page ?? this.page,
        results: results ?? this.results,
        totalPages: totalPages ?? this.totalPages,
        totalResults: totalResults ?? this.totalResults,
      );

  factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        page: json["page"],
        results: List<dynamic>.from(json["results"].map((x) => x)),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x)),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}
