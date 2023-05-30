import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/notifier/default_change_notifier.dart';
import 'package:projeto_iggdrazil/app/services/user/user_service.dart';

import '../../../exception/auth_exceptions.dart';

class RegisterController extends DefaultChangeNotifier {

  final UserService _userService;

  RegisterController({required UserService userService})
      : _userService = userService;

  Future<void> registerUser(String email, String password) async {
    try {
      showLoadingAndResetState();
      notifyListeners();
      final user = await _userService.register(email, password);
      if (user != null) {
        // sucesso
        success();
      } else {
        // erro
        setError('Erro ao registrar usuário');
      }
      notifyListeners();
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
