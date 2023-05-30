import '../../core/modules/iggdrazil_module.dart';
import 'home_page.dart';

class HomeModule extends TodoListModule {
  HomeModule()
      : super(
          // bindings: [],
          routers: {
            '/home': (context) => HomePage(),
          },
        );
}
