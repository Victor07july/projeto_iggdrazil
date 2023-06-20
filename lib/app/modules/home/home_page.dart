import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/tmdb/tmdb_api.dart';
import 'package:projeto_iggdrazil/app/modules/movie/movie_detail_screen.dart';
import 'widgets/home_drawer.dart';

class HomePage extends StatefulWidget {
  final MovieDb movieDb = new MovieDb();
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<MoviesList> movies = [];
  bool isLoading = false;
  Future<void> getMoreMovies() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      List<MoviesList> newMovies =
      await widget.movieDb.getMovies(page: movies.length ~/ 20 + 1);
      setState(() {
        isLoading = false;
        movies.addAll(newMovies);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: HomeDrawer(),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            getMoreMovies();
            return true;
          }
          return false;
        },
        child: ListView.builder(
          itemCount: movies.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == movies.length) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              MoviesList movie = movies[index];
              return ListTile(
                title: Text(movie.title),
                leading: Image.network(
                    "https://image.tmdb.org/t/p/w200${movie.posterPath}"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movieId: movie.id),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}