import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/pages/homePage.dart';
void main({debugShowCheckedModeBanner = true})async{
  await GetStorage.init();
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color.fromARGB(255, 16, 14, 42),
      accentColor: Colors.white,
      cardColor: Color.fromARGB(255, 23, 21, 56),
      buttonColor: Color.fromARGB(255, 39, 45, 218),
    ),
    title: 'Movie App',
    home: HomePage(),
  ));
}

//TODO: Watch later
//TODO: Nedávno sledováno


