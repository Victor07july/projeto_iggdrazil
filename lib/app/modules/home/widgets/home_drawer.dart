import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:projeto_iggdrazil/app/core/auth/auth_provider.dart';
import 'package:projeto_iggdrazil/app/core/ui/theme_extensions.dart';
import 'package:projeto_iggdrazil/app/services/user/user_service.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/messages.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                Selector<AuthProvider, String>(
                    selector: (context, authProvider) {
                  return authProvider.user?.photoURL ??
                      'https://media.seudinheiro.com/uploads/2019/07/shutterstock_247513390.jpg';
                }, builder: (_, value, __) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(value),
                    radius: 30,
                  );
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<AuthProvider, String>(
                        selector: (context, authProvider) {
                      return authProvider.user?.displayName ?? 'Bill Gates';
                    }, builder: (_, value, __) {
                      return Text(
                        value,
                        style: context.textTheme.titleSmall,
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('Alterar nome'),
                      content: TextField(
                        onChanged: (value) => nameVN.value = value,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                                'Cancelar',
                              style: TextStyle(color: Colors.red),
                            )
                        ),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError('Nome obrigatório');
                              } else {
                                Loader.show(context);
                                await context.read<UserService>().updateDisplayName(nameValue);
                                Loader.hide();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Alterar')),
                      ],
                    );
                  });
            },
            title: Text('Alterar nome'),
          ),
          ListTile(
            onTap: () => context.read<AuthProvider>().logout(),
            title: Text('Sair'),
          ),
          ListTile(
            title: Text('Página Inicial'),
          ),
          ListTile(
            onTap: () =>  Navigator.of(context).pushNamed('/wishlist'),
            title: Text('Lista de Desejos'),
          )
        ],
      ),
    );
  }
}
