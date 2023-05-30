import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:projeto_iggdrazil/app/exception/auth_exceptions.dart';

import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth}) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch(e, s) {
      print(e);
      print(s);
      if(e.code == 'email-already-exists'){
        final loginTypes = await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if(loginTypes.contains('password')) {
          throw AuthException(message: 'E-mail já utilizado, escolha outro e-mail');
        } else {
          throw AuthException(message: 'Você já se cadastrou pelo Google. Por favor, utilize ele para entrar.');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
    }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if(e.code == 'wrong-password') {
        throw AuthException(message: 'Login ou senha inválidos');
      }
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    }

  }

  @override
  Future<void> forgotPassword(String email) async {
    final loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

    try {
      if(loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if(loginMethods.contains('google')) {
        throw AuthException(message: 'Cadastro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthException(message: 'E-mail não encontrado');

      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
      
        if(loginMethods.contains('password')) {
          throw AuthException(message: 'Você já utilizou o e-mail para cadastro.');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken
          );
          var userCredential = await _firebaseAuth.signInWithCredential(firebaseCredential);
          return userCredential.user;
        }
      
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if(e.code == 'account-exists-with-different-credential') {
        throw AuthException(message: 'Login inválido, você se registrou com os seguintes provedores:'
        '${loginMethods?.join(',')}'
    );
      } else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if(user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }

}