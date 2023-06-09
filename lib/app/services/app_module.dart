import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/auth/auth_provider.dart';
import 'package:projeto_iggdrazil/app/core/database/sqlite_connection_factory.dart';
import 'package:projeto_iggdrazil/app/repositories/user/user_repository_impl.dart';
import 'package:projeto_iggdrazil/app/services/app_widget.dart';
import 'package:projeto_iggdrazil/app/services/user/user_service_impl.dart';
import 'package:provider/provider.dart';

import '../repositories/user/user_repository.dart';
import 'user/user_service.dart';

// aqui ficam as classes compartilhadas entre os módulos

class AppModule extends StatelessWidget {
  const AppModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => FirebaseAuth.instance),
        Provider(
          create: (_) => SqliteConnectionFactory(),
          lazy: false,
        ),
        Provider<UserRepository>(
          create: (context) => UserRepositoryImpl(firebaseAuth: context.read()),
        ),
        Provider<UserService>(
          create: (context) => UserServiceImpl(userRepository: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
              firebaseAuth: context.read(), userService: context.read())
            ..loadListener(),
          lazy: false,
        ),
      ],
      child: AppWidget(),
    );
  }
}
