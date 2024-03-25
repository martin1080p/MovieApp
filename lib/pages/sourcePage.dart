// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/elements/contentList.dart';
import 'package:test_app/elements/roundedContainer.dart';
import 'package:test_app/functions/cast.dart';
import 'package:test_app/links/storage.dart';
import 'package:test_app/alerts/episodeSelection.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:expandable_text/expandable_text.dart';

import 'package:test_app/variables/globals.dart' as globals;

class SourceSubject {
  final int id;
  final String title;
  final String originalTitle;
  final String imageUrl;
  final String releaseYear;
  final String description;
  final double vote;
  final bool isTV;
  final double offset;

  const SourceSubject(this.id, this.title, this.originalTitle, this.imageUrl, this.releaseYear,
      this.description, this.vote, this.isTV, this.offset);
}

class SourcePage extends StatefulWidget {
  SourcePage({Key key, @required this.source}) : super(key: key);
  final SourceSubject source;

  @override
  _SourcePageState createState() => _SourcePageState();
}

class _SourcePageState extends State<SourcePage> {
  @protected
  void initState() {
    super.initState();
  }

  void dispose() {
    BackButtonInterceptor.removeAll();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool navigatorPop(bool stopDefaultButtonEvent, RouteInfo info) {
      Navigator.pop(context); // Do some stuff.
      return true;
    }

    BackButtonInterceptor.add(navigatorPop);

    double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    globals.activeId = widget.source.id;
    globals.activeTitle = widget.source.title;
    globals.activeOriginalTitle = widget.source.originalTitle;
    globals.activeImageUrl = widget.source.imageUrl;
    globals.activeDescription = widget.source.description;
    globals.activeYear = widget.source.releaseYear;
    globals.activeVote = widget.source.vote;
    globals.activeIsTV = widget.source.isTV;
    globals.activeOffset = widget.source.offset;
    //bool _titleSame = (_title == _originalTitle);

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_back_ios_new_rounded),
          backgroundColor: Colors.white.withOpacity(0.5),
          mini: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    child: Hero(
                      tag: "image" + widget.source.id.toString(),
                      child: Container(
                        height: _screenHeight / 2.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset.center,
                            image: (globals.activeImageUrl != null
                                ? NetworkImage(
                                    "https://image.tmdb.org/t/p/original" + globals.activeImageUrl)
                                : AssetImage('assets/empty_poster.jpg')),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      RoundedContainer(
                        width: _screenWidth - globals.activeOffset,
                        padding: EdgeInsets.fromLTRB(
                            globals.activeOffset, globals.activeOffset, globals.activeOffset, 0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                        child: Text(
                          widget.source.title,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: globals.activeOffset,
                    right: globals.activeOffset / 2,
                    child: RawMaterialButton(
                      autofocus: !globals.activeIsTV,
                      onPressed: () {
                        //addToStorage();
                        createVideoDialog(context, globals.firstLink);
                      },
                      elevation: 2.0,
                      fillColor: Theme.of(context).buttonColor,
                      child: Icon(
                        Icons.play_arrow,
                        size: 35.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  RoundedContainer(
                    width: _screenWidth - globals.activeOffset,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: globals.activeOffset),
                          child: Opacity(
                            opacity: 0.5,
                            child: Text(
                              globals.activeYear.replaceAllMapped(RegExp(r"[()]"), (match) {
                                return '';
                              }),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: "DINPro",
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(globals.activeOffset,
                              globals.activeOffset / 2, globals.activeOffset, globals.activeOffset),
                          child: Row(
                            children: [
                              Text(
                                globals.activeVote.toString().substring(0, 3) + " ",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "DINPro",
                                    color: Colors.amber),
                              ),
                              RatingBarIndicator(
                                rating: globals.activeVote / 2,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                                itemSize: 15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(globals.activeOffset, 0,
                              globals.activeOffset, 1.5 * globals.activeOffset),
                          child: Opacity(
                              opacity: 0.5,
                              child: ExpandableText(
                                globals.activeDescription,
                                textAlign: TextAlign.justify,
                                expandOnTextTap: true,
                                collapseOnTextTap: true,
                                animation: true,
                                animationDuration: Duration(milliseconds: 500),
                                expandText: "více",
                                collapseText: "méně",
                                maxLines: 2,
                                linkColor: Colors.blue,
                                style: TextStyle(fontFamily: "DINPro", height: 1.5),
                              )),
                        ),
                      ],
                    ),
                  ),
                  getEpisodeSelection(globals.activeIsTV, globals.activeId, globals.activeOffset,
                      context, setState),
                  RoundedContainer(
                    padding: EdgeInsets.all(globals.activeOffset),
                    margin:
                        EdgeInsets.only(top: globals.activeOffset, bottom: globals.activeOffset),
                    width: _screenWidth - globals.activeOffset,
                    child: Column(
                      children: [
                        getCast(
                            globals.activeId, globals.activeIsTV, globals.activeOffset, context),
                        getDirector(
                            globals.activeId, globals.activeIsTV, globals.activeOffset, context),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                            bottom: globals.activeOffset / 2, left: globals.activeOffset),
                        child: Text(
                          "Zdroje",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                        ),
                      ),
                      Container(
                          //height: _screenHeight / 4,
                          width: _screenWidth - globals.activeOffset,
                          color: Theme.of(context).primaryColor,
                          child: FutureBuilder(
                            future: generateStorageLinks(
                                globals.activeIsTV
                                    ? "${globals.activeTitle} " +
                                        globals.actualSelectedSeason.toString().padLeft(2, "0") +
                                        "x" +
                                        globals.actualSelectedEpisode.toString().padLeft(2, "0")
                                    : "${globals.activeTitle} ${globals.activeYear}",
                                globals.activeIsTV
                                    ? "${globals.activeOriginalTitle} " +
                                        globals.actualSelectedSeason.toString().padLeft(2, "0") +
                                        "x" +
                                        globals.actualSelectedEpisode.toString().padLeft(2, "0")
                                    : "${globals.activeOriginalTitle} ${globals.activeYear}",
                                setState,
                                "cz",
                                globals.activeOffset),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return snapshot.data;
                              }
                              return Align(
                                  alignment: Alignment.topCenter, child: LinearProgressIndicator());
                            },
                          )),
                    ],
                  ),
                  RoundedContainer(
                    width: _screenWidth - globals.activeOffset,
                    margin: EdgeInsets.only(top: globals.activeOffset),
                    padding: EdgeInsets.all(globals.activeOffset),
                    child: globals.activeIsTV
                        ? SimilarShowsList(
                            globals.activeId, _screenHeight / 4, globals.activeOffset)
                        : SimilarMoviesList(
                            globals.activeId, _screenHeight / 4, globals.activeOffset),
                  ),
                  callBack(
                      child: Container(
                    height: globals.activeOffset,
                  )),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  callBack({Widget child}) {
    //globals.actualSelectedSeason = 1;
    //globals.actualSelectedEpisode = 1;
    globals.firstLinkFetched = false;
    return child;
  }

  getEpisodeSelection(bool isTV, int id, double offset, BuildContext context, Function setState) {
    if (isTV) {
      return RoundedContainer(
        padding: EdgeInsets.only(right: offset, left: offset, top: offset / 2, bottom: offset / 2),
        margin: EdgeInsets.only(top: offset),
        width: MediaQuery.of(context).size.width - offset,
        child: InkWell(
          autofocus: true,
          onTap: () {
            episodeSelection(context, id, setState);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        "Výběr epizody",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontFamily: "DINPro"),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sezóna ${globals.actualSelectedSeason}, Epizoda ${globals.actualSelectedEpisode}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "DINPro",
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      );
    } else
      return Container();
  }
}
