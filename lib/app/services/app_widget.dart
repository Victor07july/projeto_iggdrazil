import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/database/sqlite_adm_connection.dart';
import 'package:projeto_iggdrazil/app/core/navigator/todo_list_navigator.dart';
import 'package:projeto_iggdrazil/app/core/ui/todo_list_ui_config.dart';
import 'package:projeto_iggdrazil/app/modules/auth/login/login_page.dart';
import 'package:projeto_iggdrazil/app/modules/movie/movie_detail_screen.dart';
import 'package:projeto_iggdrazil/app/modules/splash/splash_page.dart';
import 'package:projeto_iggdrazil/app/modules/wishlist/wishlist_page.dart';
import 'package:provider/provider.dart';

import '../modules/auth/auth_module.dart';
import '../modules/auth/login/login_controller.dart';
import '../modules/home/home_module.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final sqliteAdmConnection = SqliteAdmConnection();

  @override
  void initState() {
    super.initState();
    FirebaseAuth auth = FirebaseAuth.instance;
    WidgetsBinding.instance?.addObserver(sqliteAdmConnection);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(sqliteAdmConnection);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iggdrazil',
      theme: TodoListUiConfig.theme,
      navigatorKey: TodoListNavigator.navigatorKey,
      routes: {
        ...AuthModule().routers,
        ...HomeModule().routers,
        '/wishlist': (context) => WishListPage(),
      },
      home: SplashPage(),
    );
  }
}
