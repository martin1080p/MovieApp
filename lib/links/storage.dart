import 'dart:convert';
import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:test_app/pages/moviePlayer.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as html;

import 'package:http/http.dart' as http;
import 'package:test_app/variables/globals.dart' as globals;
import 'package:test_app/video_fetchers/storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: non_constant_identifier_names
RegExp dabing_regex = RegExp(r"(?:[^a-ž]|^)(?:cz|cze|česky|český|dabing|czdab)(?:[^a-ž]|$)",
    caseSensitive: false, multiLine: true);
// ignore: non_constant_identifier_names
RegExp subtitle_regex = RegExp(r"(?:[^a-Ž]|^|cz|cze)(?:titulky|tit)(?:[^a-Ž]|$)",
    caseSensitive: false, multiLine: true);
// ignore: non_constant_identifier_names
RegExp high_regex =
    RegExp(r"(?:[^a-ž]|^)(?:1080p|2160p|4k|uhd)", caseSensitive: false, multiLine: true);
// ignore: non_constant_identifier_names
RegExp diacritics_regex = RegExp(r'[À-ž]', caseSensitive: false, multiLine: true);

Future generateStorageLinks(String searchTerm, String originalSearchTerm, Function setState,
    String keyPrefix, double offset) async {
  html.Document document = parse(
      (await http.get(Uri.parse('https://prehraj.to/hledej/${searchTerm.replaceAll(" ", "%20")}')))
          .body);
  html.Document documentOriginal = parse((await http
          .get(Uri.parse('https://prehraj.to/hledej/${originalSearchTerm.replaceAll(" ", "%20")}')))
      .body);

  List<String> usedSizes = [];

  List<String> titles = getTextListOfElements(document.querySelectorAll('h3.video__title')) +
      getTextListOfElements(documentOriginal.querySelectorAll('h3.video-video__title'));
  //List<String> images = getSrcListOfElements(parser.querySelectorAll('img.thumb1'));
  List<String> sizes = getTextListOfElements(document.querySelectorAll('div.video__tag--size')) +
      getTextListOfElements(documentOriginal.querySelectorAll('div.video__tag--size'));
  //List<String> timespans = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-time'));
  List<String> links = getHrefListOfElements(document.querySelectorAll('a.video--link')) +
      getHrefListOfElements(documentOriginal.querySelectorAll('a.video--link'));

  List<Map<String, dynamic>> prefferedList = [];
  List<Map<String, dynamic>> originalList = [];

  for (int i = 0; i < titles.length; i++) {
    //if (usedSizes.contains(sizes[i])) continue;

    usedSizes.add(sizes[i]);

    int priorityIndex = getPriorityIndex(titles[i]);

    if (priorityIndex >= 20) {
      prefferedList.add({
        "title": titles[i],
        "size": sizes[i],
        "link": links[i],
        "priority_index": priorityIndex
      });
    } else {
      originalList.add({
        "title": titles[i],
        "size": sizes[i],
        "link": links[i],
        "priority_index": priorityIndex
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
          itemCount: prefferedList.length,
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
                addToStorage();
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
                                child: classifySourceTitle(prefferedList[index]["title"], offset)),
                            //Align(alignment: Alignment.center, child: Text(sizes[index]))
                          ],
                        ))
                  ],
                ),
              ),
            );
          }),
      ListView.builder(
          padding: EdgeInsets.all(0.0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: originalList.length,
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
                addToStorage();
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
                                child: classifySourceTitle(originalList[index]["title"], offset)),
                            //Align(alignment: Alignment.center, child: Text(sizes[index]))
                          ],
                        ))
                  ],
                ),
              ),
            );
          }),
    ],
  );
}

int getPriorityIndex(String title) {
  int index = 0;
  if (subtitle_regex.hasMatch(title)) //Titulky
    index += 2;
  else if (dabing_regex.hasMatch(title) || diacritics_regex.hasMatch(title)) //Česky
    index += 20;
  if (high_regex.hasMatch(title)) //High Definition
    index += 1;
  return index;
}

bool checkLanguage(String title) {
  //True... CZ; False... Original

  return (dabing_regex.hasMatch(title) || diacritics_regex.hasMatch(title)) &&
      !subtitle_regex.hasMatch(title);
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

/*
Future<void> createVideoDialog(BuildContext context, String link) async {
  globals.activeLink = link;
  showDialog(
      context: context,
      builder: (context) {
        return MoviePlayer();
      });
}*/

Future<void> createVideoDialog(BuildContext context, String link) async {
  Map<String, dynamic> sources;
  bool loaded = false;
  bool error = false;

  Map<String, String> resolutions;
  String initialSource;
  List<BetterPlayerSubtitlesSource> subtitles;
  double aspectRatio;
  bool isTV;

  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          WebViewController controller;

          if (!loaded && !error) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Offstage(
                  child: Container(
                    height: 50,
                    child: WebView(
                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: link,
                      onWebViewCreated: (webViewController) {
                        controller = webViewController;
                      },
                      onPageFinished: (url) async {
                        sources = jsonDecode(await controller.evaluateJavascript('sources'));

                        if (sources == null) {
                          setState(() {
                            loaded = true;
                            error = true;
                          });
                        } else {
                          resolutions = Map.fromIterable(sources['videos'],
                              key: (e) => e['label'], value: (e) => e['src']);
                          initialSource = sources['videos'][0]['src'];
                          subtitles = subtitlesGenerator(sources['tracks']);
                          isTV = await isTvDevice();
                          aspectRatio = await getAspectRatio(initialSource);

                          setState(() {
                            loaded = true;
                            error = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (loaded && error) {
            return Center(
              child: AlertDialog(
                title: Text('Chyba'),
                content: Text('Chyba načítání zdrojů'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Zavřít'),
                  ),
                ],
              ),
            );
          } else if (loaded && !error) {
            return MoviePlayer(
              initialSource: initialSource,
              resolutions: resolutions,
              substitles: subtitles,
              aspectRatio: aspectRatio,
              isTV: isTV,
            );
          }

          return Container();
        });
      });
}

List<String> getTextListOfElements(List<html.Element> elements) {
  List<String> textList = [];
  for (html.Element element in elements) {
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

List<String> getHrefListOfElements(List<html.Element> elements) {
  List<String> hrefList = [];
  for (html.Element element in elements) {
    hrefList.add('https://prehraj.to' + element.attributes['href']);
  }
  return hrefList;
}

void addToStorage() {
  List<dynamic> watchedList = GetStorage().read('watched_list');
  if (watchedList == null) watchedList = [];

  watchedList.insert(0, {
    "title": globals.activeTitle,
    "image": globals.activeImageUrl,
    "id": globals.activeId,
    "description": globals.activeDescription,
    "is_tv": globals.activeIsTV,
    "season": globals.actualSelectedSeason,
    "episode": globals.actualSelectedEpisode,
    "time_now": DateFormat('hh:mm').format(DateTime.now()),
    "date_now": DateFormat('dd/MM/yyyy').format(DateTime.now())
  });
  GetStorage().write('watched_list', watchedList);
}
