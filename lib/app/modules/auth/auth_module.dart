import 'package:projeto_iggdrazil/app/core/modules/iggdrazil_module.dart';
import 'package:projeto_iggdrazil/app/modules/auth/login/login_controller.dart';
import 'package:projeto_iggdrazil/app/modules/auth/login/login_page.dart';
import 'package:projeto_iggdrazil/app/modules/auth/register/register_controller.dart';
import 'package:projeto_iggdrazil/app/modules/auth/register/register_page.dart';
import 'package:provider/provider.dart';

class AuthModule extends TodoListModule {
  AuthModule(): super(
    bindings: [
      ChangeNotifierProvider(create: (context) => LoginController(userService: context.read()),
      ),
      ChangeNotifierProvider(
        create: (context) => RegisterController(userService: context.read()),
      ),
    ],
    routers: {
      '/login': (context) => LoginPage(),
      '/register': (context) => RegisterPage(),
    }
  );
}