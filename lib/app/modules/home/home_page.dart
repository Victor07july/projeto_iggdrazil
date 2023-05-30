import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/movie/movies_list.dart';
import 'package:projeto_iggdrazil/app/modules/home/widgets/home_drawer.dart';


class HomePage extends StatelessWidget {

  final MovieDb movieDb = new MovieDb();

  HomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'),),
      drawer: HomeDrawer(),
      body: FutureBuilder(
          future: movieDb.getMovies(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<MoviesList> movies = snapshot.data as List<MoviesList>;
              movies.sort((a, b) => b.id.compareTo(a.id));
              return ListView.builder(
                itemCount: movies.length,
                itemBuilder: (BuildContext context, int index) {
                  MoviesList movie = movies[index];
                  return ListTile(
                    title: Text(movie.title),
                    leading: Image.network(
                        "https://image.tmdb.org/t/p/w200${movie.posterPath}"),
                    onTap: () {
                      // NAVEGAR PARA A PÁGINA DE DETALHE DO FILME
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
      }
      ),
    );
  }
}