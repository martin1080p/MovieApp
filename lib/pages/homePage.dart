// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_app/pages/fragments/fourthFragment.dart';
import 'package:test_app/pages/searchPage.dart';
import 'package:get/get.dart';
import 'package:test_app/controllers/homepage_controller.dart';
import 'package:test_app/pages/fragments/firstFragment.dart';
import 'package:test_app/pages/fragments/secondFragment.dart';
import 'package:test_app/pages/fragments/thirdFragment.dart';
import 'package:test_app/request/api-request.dart';

class TopDrawerItem {
  String title;
  IconData icon;
  TopDrawerItem(this.title, this.icon);
}

class MiddleItem {
  String title;
  IconData icon;
  MiddleItem(this.title, this.icon);
}

class BottomItem {
  String title;
  IconData icon;
  BottomItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageController homeController = Get.put(HomePageController());

  ApiRequests apiRequests = Get.put(ApiRequests());

  final drawerItems = [
    new TopDrawerItem("Domů", Icons.house_rounded),
    new TopDrawerItem("Filmy", Icons.movie_creation_rounded),
    new TopDrawerItem("Seriály", Icons.tv_rounded)
  ];

  final middleItems = [
    new BottomItem("Moje Historie", Icons.history_rounded),
  ];

  final bottomItems = [new BottomItem("DMCA", Icons.lock_outline_rounded)];

  getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FirstFragment();
      case 1:
        return new SecondFragment();
      case 2:
        return new ThirdFragment();
      case 3:
        return new FourthFragment();

      default:
        return new Text("Error");
    }
  }

  onSelectTopItem(int index) {
    homeController.fragmentIndex.value = index;
    homeController.fetchNewData(index);
    Navigator.of(context).pop(); // close the drawer
  }

  onSelectMiddleItem(int index) {
    homeController.fragmentIndex.value = index;

    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(GetX<HomePageController>(builder: (controller) {
        return new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == controller.fragmentIndex.value,
          onTap: () => onSelectTopItem(i),
        );
      }));
    }

    List<Widget> middleOptions = [];
    for (var i = 0; i < middleItems.length; i++) {
      var b = middleItems[i];
      middleOptions.add(ListTile(
        leading: new Icon(b.icon),
        title: new Text(b.title),
        onTap: () {
          onSelectMiddleItem(i + 3);
        },
      ));
    }

    List<Widget> bottomOptions = [];
    for (var i = 0; i < bottomItems.length; i++) {
      var b = bottomItems[i];
      bottomOptions.add(ListTile(
        leading: new Icon(b.icon),
        title: new Text(b.title),
        onTap: () => {},
      ));
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Container(
                              color: Theme.of(context).cardColor,
                              height: 200,
                              child: SvgPicture.asset("assets/logo.svg"),
                            ),
                            Container(
                              child: Text(
                                'Made with ❤ by Martin Fanta',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'DINPro',
                                ),
                              ),
                              margin: EdgeInsets.only(bottom: 10),
                            ),
                          ],
                        ),
                        Column(
                          children: drawerOptions,
                        ),
                      ],
                    ),
                    Column(
                      children: middleOptions + [Divider()] + bottomOptions,
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
              body: GetX<HomePageController>(builder: (controller) {
                return getDrawerItemWidget(controller.fragmentIndex.value);
              }));
        }));
  }
}
