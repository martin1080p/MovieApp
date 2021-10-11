import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chaleno/chaleno.dart';
import 'package:test_app/pages/myVideoPlayer.dart';

import 'package:test_app/variables/globals.dart' as globals;

Future generateStorageLinks(String searchTerm, Function setState, String keyPrefix, double offset) async {
  var parser = await Chaleno().load('https://prehraj.to/hledej/${searchTerm.replaceAll(" ", "%20")}');

  List<String> titles = getTextListOfElements(parser.querySelectorAll('h2.video-item-title'));
  //List<String> images = getSrcListOfElements(parser.querySelectorAll('img.thumb1'));
  List<String> sizes = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-size'));
  //List<String> timespans = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-time'));
  List<String> links = getHrefListOfElements(parser.querySelectorAll('a.video-item-link'));

  List<String> usedSizes = [];

  return ListView.builder(
      itemCount: titles.length,
      itemBuilder: (BuildContext context, int index) {
        //double _screenWidth = MediaQuery.of(context).size.width;
        //double _screenHeight = MediaQuery.of(context).size.height;

        if (!usedSizes.contains(sizes[index])) {
          usedSizes.add(sizes[index]);

          if (index == 0 && !globals.firstLinkFetched) {
            globals.firstLink = links[index];
          }

          return InkWell(
            key: Key(keyPrefix + index.toString()),
            onTap: () {
              createVideoDialog(context, links[index]);
            },
            child: Container(
              child: (Container(
                child: Container(
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
                                  titles[index], //"Source ${index+1}",//
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
                              Align(alignment: Alignment.center, child: classifySourceTitle(titles[index], offset)),
                              //Align(alignment: Alignment.center, child: Text(sizes[index]))
                            ],
                          ))
                    ],
                  ),
                ),
              )),
            ),
          );
        }
        return Container();
      });
}

Widget classifySourceTitle(String _title, double _offset) {
  RegExp fullReg = RegExp(r"(?:[^a-ž]|^)(?:1080p|2160p|4k|uhd)", caseSensitive: false, multiLine: true);

  RegExp subtitleReg = RegExp(r"(?:[^a-ž]|^)(?:titulky|tit)(?:[^a-ž]|$)", caseSensitive: false, multiLine: true);

  RegExp soundReg = RegExp(r"(?:[^a-ž]|^)(?:cz|cze|česky|český|dabing|czdab)(?:[^a-ž]|$)", caseSensitive: false, multiLine: true);

  List<Widget> allFlags = [];

  if (fullReg.hasMatch(_title)) {
    allFlags.add(getSourceFlags(_offset, "Full HD", Colors.green));
  }

  if (subtitleReg.hasMatch(_title)) {
    allFlags.add(getSourceFlags(_offset, "Titulky", Colors.yellow));
  } else if (soundReg.hasMatch(_title)) {
    allFlags.add(getSourceFlags(_offset, "Dabing", Colors.orange));
  }
  return Row(children: allFlags);
}

Container getSourceFlags(double _offset, String flagText, Color flagColor) {
  return Container(
    padding: EdgeInsets.all(_offset / 5),
    margin: EdgeInsets.all(_offset / 5),
    decoration: BoxDecoration(border: Border.all(width: 2, color: flagColor), borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Text(
      flagText,
      style: TextStyle(color: flagColor, fontSize: 13),
    ),
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
