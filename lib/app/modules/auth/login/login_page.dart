import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/core/notifier/default_listener_notifier.dart';
import 'package:projeto_iggdrazil/app/core/widget/todo_list_field.dart';
import 'package:projeto_iggdrazil/app/core/widget/todo_list_logo.dart';
import 'package:projeto_iggdrazil/app/modules/auth/login/login_controller.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:validatorless/validatorless.dart';

import '../../../core/ui/messages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
      context: context,
      everCallback: (notifier, listenerInstance) {
        if(notifier is LoginController) {
          if (notifier.hasInfo) {
            Messages.of(context).showInfo(notifier.infoMessage!);
          }
        }
      },
      successCallBack: (notifier, listenerInstance) {
        // DIRECIONAR PARA A HOMEPAGE
        print('Login efetuado com sucesso!');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginController>(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TodoListField(
                                label: 'E-mail',
                                controller: _emailEC,
                                focusNode: _emailFocus,
                                validator: Validatorless.multiple([
                                  Validatorless.required('E-mail obrigatório'),
                                  Validatorless.email('E-mail inválido')
                                ]),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TodoListField(
                                  label: 'Senha',
                                  controller: _passwordEC,
                                  obscureText: true,
                                  validator: Validatorless.multiple([
                                    Validatorless.required('Senha obrigatória'),
                                    Validatorless.min(6, 'Senha deve conter pelo menos 6 caracteres',)
                                  ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        if(_emailEC.text.isNotEmpty) {
                                          context.read<LoginController>().forgotPassword(_emailEC.text);
                                        } else {
                                          _emailFocus.requestFocus();
                                          Messages.of(context).showError(('Digite um e-mail para recuperar a senha'));
                                        }
                                      },
                                      child: Text('Esqueceu a senha?')),
                                  ElevatedButton(
                                    onPressed: () {
                                      final formValid = _formKey.currentState?.validate() ?? false;
                                      if(formValid) {
                                        final email = _emailEC.text;
                                        final password = _passwordEC.text;
                                        context.read<LoginController>().login(email, password);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('Login'),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffF0F3F7),
                          border: Border(
                              top: BorderSide(
                                  width: 2, color: Colors.grey.withAlpha(50)))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          SignInButton(
                            Buttons.google,
                            onPressed: () {
                              context.read<LoginController>().googleLogin();
                            },
                            text: 'Continue com o Google',
                            padding: EdgeInsets.all(5),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Não tem conta?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  child: Text('Cadastre-se'))
                            ],
                          )
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
