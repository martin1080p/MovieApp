import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/pages/searchPage.dart';

import 'package:test_app/pages/fragments/firstFragment.dart';
import 'package:test_app/pages/fragments/secondFragment.dart';
import 'package:test_app/pages/fragments/thirdFragment.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {

  

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final drawerItems = [
    new DrawerItem("Fragment 1", Icons.rss_feed),
    new DrawerItem("Fragment 2", Icons.local_pizza),
    new DrawerItem("Fragment 3", Icons.info)
  ];

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new SecondFragment();
      case 2:
        return new ThirdFragment();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: OrientationBuilder(builder: (BuildContext context, Orientation orientation) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            drawer: Drawer(
              child: Column(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text("Martin Fanta"),
                    accountEmail: null,
                  ),
                  Column(
                    children: drawerOptions,
                  )
                ],
              ),
            ),
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
            body: _getDrawerItemWidget(_selectedDrawerIndex),
          );
        }));
  }
}