import 'dart:convert';
import 'package:http/http.dart' as http;

void fetchMovieDetails() async {
  final String apiKey = 'sua_api_key';
  final int movieId = 12345; // ID do filme desejado

  final Uri uri = Uri.https('api.themoviedb.org', '/3/movie/$movieId', {
    'api_key': apiKey,
  });

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final movieDetails = jsonDecode(response.body);

    // Processar os detalhes do filme
    final String title = movieDetails['title'];
    final String overview = movieDetails['overview'];
    final String releaseDate = movieDetails['release_date'];
    final double rating = movieDetails['vote_average'];

    // Exibir os detalhes do filme
    print('Título: $title');
    print('Descrição: $overview');
    print('Data de lançamento: $releaseDate');
    print('Avaliação: $rating');

    // ... Faça outras operações com os detalhes do filme ...

  } else {
    print('Erro na requisição: ${response.statusCode}');
  }
}

void main() {
  fetchMovieDetails();
}
