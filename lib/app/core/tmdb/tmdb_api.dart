import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesList {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  MoviesList({required this.id, required this.title, required this.posterPath, required this.overview});
  factory MoviesList.fromJson(Map<String, dynamic> json) {
    return MoviesList(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
    );
  }
}

class MovieDetail {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final String releaseDate;
  final int runtime;
  MovieDetail({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.runtime,
  });
  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      runtime: json['runtime'],
    );
  }
}
class MovieDb {
  final String apiKey = '59f7c99a5fee79ee708bbadde1b889c4';
  Future<List<MoviesList>> getMovies({int page = 1}) async {
    final moviesUrl =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&page=$page";
    final response = await http.get(Uri.parse(moviesUrl));
    if (response.statusCode == 200) {
      List<dynamic> movies = json.decode(response.body)['results'];
      List<MoviesList> moviesList = [];
      for (var movie in movies) {
        moviesList.add(MoviesList.fromJson(movie));
      }
      return moviesList;
    } else {
      throw Exception('Failed to load movies');
    }
  }
  Future<MovieDetail> getMovieDetail(int movieId) async {
    final movieDetailUrl =
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey";
    final response = await http.get(Uri.parse(movieDetailUrl));
    if (response.statusCode == 200) {
      MovieDetail movieDetail = MovieDetail.fromJson(json.decode(response.body));
      return movieDetail;
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}