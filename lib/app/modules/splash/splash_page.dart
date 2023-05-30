import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/widget/todo_list_logo.dart';

class SplashPage  extends StatelessWidget {
  const SplashPage ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TodoListLogo(),
        ),
      );
  }
}
