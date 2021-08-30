import 'package:flutter/material.dart';
import 'package:test_app/pages/searchPage.dart';
import 'package:flutter/services.dart';

void main({debugShowCheckedModeBanner=true}) {
  runApp(MaterialApp(
    theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color.fromARGB(255, 16, 14, 42),
        accentColor: Colors.white,
        cardColor: Color.fromARGB(255, 23, 21, 56),
        buttonColor: Color.fromARGB(255, 39, 45, 218),
        ),
    title: 'Movie App',
    home: MainPage(),
  ));
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              drawer: Drawer(),
              appBar: AppBar(
                elevation: 0,
                iconTheme: IconThemeData(color: Theme.of(context).accentColor),
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                      icon: Icon(Icons.search)),
                ],
              ),
            );
          }
        ));
  }
}
