import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/tmdb/tmdb_api.dart';
import 'package:projeto_iggdrazil/app/modules/home/widgets/home_drawer.dart';


class MovieDetailScreen extends StatelessWidget {
  final MoviesList movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      drawer: HomeDrawer(),
      body: Center(
        child: Text(movie.overview),
      ),
    );
  }
}