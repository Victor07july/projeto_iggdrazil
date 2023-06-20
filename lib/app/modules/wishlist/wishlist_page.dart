import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/tmdb/tmdb_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../movie/movie_detail_screen.dart';

class WishListPage extends StatefulWidget {
  WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<MovieDetail> wishlistMovies = [];

  Future<List<MovieDetail>> getWishlistMovies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Obter a lista de desejos atual
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    List<MovieDetail> wishlistMovies = [];

    // Obter os detalhes dos filmes a partir da lista de desejos
    for (String movieId in wishlist) {
      MovieDetail movieDetail = await MovieDb().getMovieDetail(int.parse(movieId));
      wishlistMovies.add(movieDetail);
    }

    return wishlistMovies;
  }

  void removeMovieFromWishlist(String movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    // Remove o filme da lista de desejos
    wishlist.remove(movieId);
    await prefs.setStringList('wishlist', wishlist);

    setState(() {
      // Atualiza a lista de desejos
      wishlistMovies.removeWhere((movie) => movie.id == movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Desejos'),
      ),
      body: FutureBuilder<List<MovieDetail>>(
        future: getWishlistMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<MovieDetail> wishlistMovies = snapshot.data!;
            return ListView.builder(
              itemCount: wishlistMovies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                      "https://image.tmdb.org/t/p/w200${wishlistMovies[index].posterPath}"),
                  title: Text(wishlistMovies[index].title),
                  subtitle: Text(wishlistMovies[index].releaseDate),
                  // Adicione mais informações do filme se desejar
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      removeMovieFromWishlist(wishlistMovies[index].id.toString());
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailScreen(movieId: wishlistMovies[index].id),
                      ),
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar a lista de desejos'),
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
