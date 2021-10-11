import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chaleno/chaleno.dart';
import 'package:test_app/pages/myVideoPlayer.dart';

import 'package:test_app/variables/globals.dart' as globals;

RegExp dabing_regex = RegExp(r"(?:[^a-ž]|^)(?:cz|cze|česky|český|dabing|czdab)(?:[^a-ž]|$)", caseSensitive: false, multiLine: true);
RegExp subtitle_regex = RegExp(r"(?:[^a-Ž]|^|cz|cze)(?:titulky|tit)(?:[^a-Ž]|$)", caseSensitive: false, multiLine: true);
RegExp high_regex = RegExp(r"(?:[^a-ž]|^)(?:1080p|2160p|4k|uhd)", caseSensitive: false, multiLine: true);
RegExp diacritics_regex = RegExp(r'[À-ž]', caseSensitive: false, multiLine: true);

Future generateStorageLinks(String searchTerm, String originalSearchTerm, Function setState,
    String keyPrefix, double offset) async {
  var parser = await Chaleno().load('https://prehraj.to/hledej/${searchTerm.replaceAll(" ", "%20")}');
  var parserOriginal = await Chaleno().load('https://prehraj.to/hledej/${originalSearchTerm.replaceAll(" ", "%20")}');

  List<String> usedSizes = [];

  List<String> titles =
      getTextListOfElements(parser.querySelectorAll('h2.video-item-title')) +
      getTextListOfElements(parserOriginal.querySelectorAll('h2.video-item-title'));
  //List<String> images = getSrcListOfElements(parser.querySelectorAll('img.thumb1'));
  List<String> sizes = 
      getTextListOfElements(parser.querySelectorAll('strong.video-item-info-size')) +
      getTextListOfElements(parserOriginal.querySelectorAll('strong.video-item-info-size'));
  //List<String> timespans = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-time'));
  List<String> links =
      getHrefListOfElements(parser.querySelectorAll('a.video-item-link')) + 
      getHrefListOfElements(parserOriginal.querySelectorAll('a.video-item-link'));

  List<Map<String, dynamic>> prefferedList = [];
  List<Map<String, dynamic>> originalList = [];
  
  for (int i = 0; i < titles.length; i++) {

    if(usedSizes.contains(sizes[i]))
      continue;
    
    usedSizes.add(sizes[i]);

    int priorityIndex = getPriorityIndex(titles[i]);
    
    if(priorityIndex >= 20){
      prefferedList.add({
        "title" : titles[i],
        "size" : sizes[i],
        "link" : links[i],
        "priority_index" : priorityIndex
      });
    }
    else {
      originalList.add({
        "title" : titles[i],
        "size" : sizes[i],
        "link" : links[i],
        "priority_index" : priorityIndex
      });
    }
    
  }

  originalList.sort((a, b) => a["priority_index"].compareTo(b["priority_index"]));
  prefferedList.sort((a, b) => a["priority_index"].compareTo(b["priority_index"]));

  originalList = new List.from(originalList.reversed);
  prefferedList = new List.from(prefferedList.reversed);

  return Column(
    children: [
      ListView.builder(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
          itemCount: min(2, prefferedList.length),
          itemBuilder: (BuildContext context, int index) {
            //double _screenWidth = MediaQuery.of(context).size.width;
            //double _screenHeight = MediaQuery.of(context).size.height;

              if (index == 0 && !globals.firstLinkFetched) {
                globals.firstLink = prefferedList[index]["link"];
                globals.firstLinkFetched = true;
              }

              return InkWell(
                key: Key(keyPrefix + index.toString()),
                onTap: () {
                  createVideoDialog(context, prefferedList[index]["link"]);
                },
                child: Container(
                  margin: EdgeInsets.only(left: offset / 2, right: offset / 2, bottom: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          //width: _screenWidth * 0.5,
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  prefferedList[index]["title"], //"Source ${index+1}",//
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: classifySourceTitle(
                                      prefferedList[index]["title"], offset)),
                              //Align(alignment: Alignment.center, child: Text(sizes[index]))
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }
      ),
      ListView.builder(
        padding: EdgeInsets.all(0.0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
          itemCount: min(1, originalList.length),
          itemBuilder: (BuildContext context, int index) {
            //double _screenWidth = MediaQuery.of(context).size.width;
            //double _screenHeight = MediaQuery.of(context).size.height;

              if (index == 0 && !globals.firstLinkFetched) {
                globals.firstLink = originalList[index]["link"];
                globals.firstLinkFetched = true;
              }

              return InkWell(
                key: Key(keyPrefix + index.toString()),
                onTap: () {
                  createVideoDialog(context, originalList[index]["link"]);
                },
                child: Container(
                  margin: EdgeInsets.only(left: offset / 2, right: offset / 2, bottom: 5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          //width: _screenWidth * 0.5,
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  originalList[index]["title"], //"Source ${index+1}",//
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                ),
                              )),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: classifySourceTitle(
                                      originalList[index]["title"], offset)),
                              //Align(alignment: Alignment.center, child: Text(sizes[index]))
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }
      ),
    ],
  );
}

int getPriorityIndex(String title) {

  int index = 0;
  if(subtitle_regex.hasMatch(title))   //Titulky
    index += 2;
  else if(dabing_regex.hasMatch(title) || diacritics_regex.hasMatch(title))  //Česky
    index += 20;
  if(high_regex.hasMatch(title))    //High Definition
    index += 1;
  return index;
}

bool checkLanguage(String title){ //True... CZ; False... Original

  return (dabing_regex.hasMatch(title) || diacritics_regex.hasMatch(title)) && !subtitle_regex.hasMatch(title);
}

Widget classifySourceTitle(String _title, double _offset) {

  List<Widget> allFlags = [];

  if (high_regex.hasMatch(_title)) {
    allFlags.add(
      getSourceFlags(
        _offset,
        Icon(
          Icons.high_quality,
          color: Colors.green,
        ),
      ),
    );
  }

  if (subtitle_regex.hasMatch(_title)) {
    allFlags.add(
      getSourceFlags(
        _offset,
        Icon(
          Icons.subtitles,
          color: Colors.yellow,
        ),
      ),
    );
  } else if (dabing_regex.hasMatch(_title)) {
    allFlags.add(
      getSourceFlags(
        _offset,
        Icon(
          Icons.volume_up,
          color: Colors.orange,
        ),
      ),
    );
  }
  return Row(children: allFlags);
}

Container getSourceFlags(double _offset, Widget flagWidget) {
  return Container(
    //padding: EdgeInsets.all(_offset / 5),
    margin: EdgeInsets.all(_offset / 5),
    //decoration: BoxDecoration(border: Border.all(width: 2, color: flagText.), borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: flagWidget,
  );
}

Future<Widget> createVideoDialog(BuildContext context, String link) async {
  globals.activeLink = link;
  showDialog(
      context: context,
      builder: (context) {
        return MyVideoPlayer();
      });
  return (Container());
}

List<String> getTextListOfElements(List<Result> elements) {
  List<String> textList = [];
  for (Result element in elements) {
    textList.add(element.text);
  }
  return textList;
}

List<String> getSrcListOfElements(List<Result> elements) {
  List<String> srcList = [];
  for (Result element in elements) {
    srcList.add(element.src);
  }
  return srcList;
}

List<String> getHrefListOfElements(List<Result> elements) {
  List<String> hrefList = [];
  for (Result element in elements) {
    hrefList.add('https://prehraj.to' + element.href);
  }
  return hrefList;
}
