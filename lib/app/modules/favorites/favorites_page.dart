import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_iggdrazil/app/modules/home/widgets/home_drawer.dart';

class FavoritesPage extends StatelessWidget {

  FavoritesPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos'),),
      drawer: HomeDrawer(),
      body: Container(),
    );
  }


}