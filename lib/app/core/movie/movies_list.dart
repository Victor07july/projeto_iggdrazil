import 'package:http/http.dart' as http;
import 'dart:convert';

class MoviesList {
  final int id;
  final String title;
  final String posterPath;
  MoviesList({required this.id, required this.title, required this.posterPath});
  factory MoviesList.fromJson(Map<String, dynamic> json) {
    return MoviesList(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
    );
  }
}

class MovieDb {
  final String apiKey = '59f7c99a5fee79ee708bbadde1b889c4';
  Future<List<MoviesList>> getMovies() async {
    final moviesUrl =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
    final response = await http.get(Uri.parse(moviesUrl));
    if (response.statusCode == 200) {
      List movies = json.decode(response.body)['results'];
      List<MoviesList> moviesList = [];
      for (var movie in movies) {
        moviesList.add(MoviesList.fromJson(movie));
      }
      return moviesList;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
