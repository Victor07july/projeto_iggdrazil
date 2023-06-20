import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/tmdb/tmdb_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();

  static MovieDb get movieDb => new MovieDb();
  // defina o getter aqui

}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> _futureMovieDetail;
  @override
  void initState() {
    super.initState();
    _futureMovieDetail = MovieDetailScreen.movieDb.getMovieDetail(widget.movieId);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Detail'),
      ),
      body: FutureBuilder<MovieDetail>(
        future: _futureMovieDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            MovieDetail movieDetail = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                      "https://image.tmdb.org/t/p/w500${movieDetail.posterPath}"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieDetail.title,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Release Date: ${movieDetail.releaseDate}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movieDetail.overview,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching movie details'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
