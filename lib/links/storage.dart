import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:test_app/video_fetchers/storage.dart';
import 'package:chaleno/chaleno.dart';
import 'package:better_player/better_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_app/pages/myVideoPlayer.dart';

import 'package:test_app/variables/globals.dart' as globals;

int _selectedItem = 0;


Future generateStorageLinks(String searchTerm, Function setState, String keyPrefix) async {
  var parser = await Chaleno().load('https://prehraj.to/hledej/${searchTerm.replaceAll(" ", "%20")}');

  List<String> titles = getTextListOfElements(parser.querySelectorAll('h2.video-item-title'));
  List<String> images = getSrcListOfElements(parser.querySelectorAll('img.thumb1'));
  List<String> sizes = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-size'));
  List<String> timespans = getTextListOfElements(parser.querySelectorAll('strong.video-item-info-time'));
  List<String> links = getHrefListOfElements(parser.querySelectorAll('a.video-item-link'));

  return ListView.builder(
          itemCount: titles.length,
          itemBuilder: (BuildContext context, int index) {
            double _screenWidth = MediaQuery.of(context).size.width;
            double _screenHeight = MediaQuery.of(context).size.height;

            if(index == 0 && !globals.firstLinkFetched){globals.firstLink = links[index];}

            return InkWell(
              key: Key(keyPrefix + index.toString()),
              onTap: (){
                createVideoDialog(context, links[index]);
              },
              child: Container(
                child: (Container(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))
                    ),
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
                                    titles[index],
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
                                  child: Text(
                                    timespans[index],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            //Align(alignment: Alignment.center, child: Text(sizes[index]))
                          ],
                        ))
                      ],
                    ),
                  ),
                )),
              ),
            );
          });
}


Future<Widget> createVideoDialog(BuildContext context, String link) async {
  globals.activeLink = link;
  showDialog(
      context: context,
      builder: (context) {
        return MyVideoPlayer();
      });
}

void _launchURL(String _url) async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

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
