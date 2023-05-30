import 'package:flutter/material.dart';

class TodoListLogo extends StatelessWidget {
  const TodoListLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/logo_imdb.png', height: 200,),
        Text('Filmes Iggdrazil', style: Theme.of(context).textTheme.titleLarge), // SEM USAR O THEME_EXTENSIONS
      ],
    );
  }
}
