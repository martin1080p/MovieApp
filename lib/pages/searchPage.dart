import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/functions/regex.dart';
import 'package:test_app/functions/data.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:test_app/elements/searchItem.dart';

class Series {
  final int season;
  final int episode;

  const Series(this.season, this.episode);
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var _controller = TextEditingController();
  String _searchText = "";

  @protected
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          theme: Theme.of(context),
          home: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: AppBar(
                elevation: 0,
                title: TextField(
                  onSubmitted: (text) {
                    Future.delayed(const Duration(seconds: 2), () {});
                    setState(() {
                      _searchText = "$text";
                    });
                  },
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  cursorColor: Colors.white,
                  cursorWidth: 1.0,
                  autofocus: true,
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).accentColor),
                    ),
                    hintText: 'Vyhledej film nebo seriál...',
                    suffixIcon: IconButton(
                      color: Theme.of(context).accentColor,
                      onPressed: _controller.clear,
                      icon: Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              body: FutureBuilder(
                future: fetchSearchResults(_searchText, context),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text("none");
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      return LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor),
                      );
                    case ConnectionState.done:
                      return snapshot.data;
                    default:
                      return Text("");
                  }
                },
              )),
        ));
  }

  Future fetchSearchResults(String text, BuildContext ctx) async {
    if (text != "") {
      String inputYear =
          getRegexMatch(text, '\\b(?:(?:19[0-9][0-9])|(?:20[0-9][0-9]))\\b');

      text = inputYear != null ? text.replaceAll(inputYear, "") : text;

      Uri movieUrl = Uri.parse(
          'https://api.themoviedb.org/3/search/movie?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ&query=$text&page=1&include_adult=false&primary_release_year=$inputYear');
      var movieResults = jsonDecode((await http.get(movieUrl)).body)["results"];
      Uri tvUrl = Uri.parse(
          'https://api.themoviedb.org/3/search/tv?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ&page=1&query=$text&include_adult=false&first_air_date_year=$inputYear');
      var tvResults = jsonDecode((await http.get(tvUrl)).body)["results"];

      return OrientationBuilder(builder: (context, orientation) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(
                color: Theme.of(context).accentColor,
                indent: 100,
                thickness: 2,
                height: 1,
              ),
              StickyHeader(
                header: Row(children: [
                  Expanded(child: Text("")),
                  Container(
                    //Movies section
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0))),
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Filmy",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ]),
                content: Container(
                  //Movies
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      String _movieImageUrl =
                          movieResults[index]["poster_path"];
                      String _movieTitle = movieResults[index]["title"];
                      String _movieOriginalTitle =
                          !checkEmptyNull(movieResults[index]["original_title"])
                              ? movieResults[index]["original_title"]
                              : _movieTitle;
                      String _movieReleaseYear =
                          !checkEmptyNull(movieResults[index]["release_date"])
                              ? " (" +
                                  DateTime.parse(
                                          movieResults[index]["release_date"])
                                      .year
                                      .toString() +
                                  ")"
                              : "";
                      String _movieDescription =
                          !checkEmptyNull(movieResults[index]["overview"])
                              ? movieResults[index]["overview"]
                              : "";

                      int _movieId = movieResults[index]["id"];
                      double _movieVote =
                          movieResults[index]["vote_average"].toDouble();

                      return getSearchItem(
                          context,
                          _movieId,
                          _movieTitle,
                          _movieOriginalTitle,
                          _movieImageUrl,
                          _movieReleaseYear,
                          _movieDescription,
                          _movieVote,
                          false);
                    },
                    itemCount: min(movieResults.length, 40),
                  ),
                ),
              ),
              Divider(
                color: Theme.of(context).accentColor,
                indent: 100,
                thickness: 1,
                height: 1,
              ),
              StickyHeader(
                header: Row(children: [
                  Expanded(child: Text("")),
                  Container(
                    //TV Shows section
                    decoration: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0))),
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Seriály",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18.0,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ]),
                content: Container(
                  //TV Shows
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      String _tvImageUrl = tvResults[index]["poster_path"];
                      String _tvTitle = tvResults[index]["name"];
                      String _tvOriginalTitle =
                          !checkEmptyNull(tvResults[index]["original_name"])
                              ? tvResults[index]["original_name"]
                              : _tvTitle;
                      String _tvReleaseYear = !checkEmptyNull(
                              tvResults[index]["first_air_date"])
                          ? " (" +
                              DateTime.parse(tvResults[index]["first_air_date"])
                                  .year
                                  .toString() +
                              ")"
                          : "";
                      String _tvDescription =
                          !checkEmptyNull(tvResults[index]["overview"])
                              ? tvResults[index]["overview"]
                              : "";
                      int _tvId = tvResults[index]["id"];
                      double _tvVote =
                          tvResults[index]["vote_average"].toDouble();

                      return getSearchItem(
                          context,
                          _tvId,
                          _tvTitle,
                          _tvOriginalTitle,
                          _tvImageUrl,
                          _tvReleaseYear,
                          _tvDescription,
                          _tvVote,
                          true);
                    },
                    itemCount: min(tvResults.length, 40),
                  ),
                ),
              )
            ],
          ),
        );
      });
    }
    return Text("");
  }
}
