import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/variables/globals.dart' as globals;
import 'package:flutter_number_picker/flutter_number_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

episodeSelection(BuildContext context, int tvId, Function setState_mainContent) async {
  return showDialog(
      context: context,
      builder: (context) {
        int currentSeason = 1;
        int currentEpisode = 1;

        return StatefulBuilder(builder: (context, setState) {
          return Shortcuts(
            shortcuts: <LogicalKeySet, Intent>{
              LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
            },
            child: AlertDialog(
                title: Text("Choose Episode"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: FutureBuilder(
                    future: fetchTvInfo(tvId, currentSeason),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text("Connection Error");
                        case ConnectionState.waiting:
                          return getAlertPlaceHolder(currentSeason, currentEpisode);
                        case ConnectionState.active:
                          return Text("");
                        case ConnectionState.done:
                          return Column(
                            children: [
                              Text("Season"),
                              Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle_outline_outlined),
                                      onPressed: () {
                                        if (currentSeason > 1) {
                                          setState(() {
                                            currentSeason--;
                                            currentEpisode = 1;
                                          });
                                        } else {
                                          setState(() {
                                            currentSeason = snapshot.data[0];
                                            currentEpisode = 1;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(child: Align(alignment: Alignment.center, child: Text(currentSeason.toString()))),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle_outline_outlined),
                                      onPressed: () {
                                        if (currentSeason < snapshot.data[0]) {
                                          setState(() {
                                            currentSeason++;
                                            currentEpisode = 1;
                                          });
                                        } else {
                                          setState(() {
                                            currentSeason = 1;
                                            currentEpisode = 1;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                              Text("Episode"),
                              Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.remove_circle_outline_outlined),
                                      onPressed: () {
                                        if (currentEpisode > 1) {
                                          setState(() {
                                            currentEpisode--;
                                          });
                                        } else {
                                          setState(() {
                                            currentEpisode = snapshot.data[1];
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(child: Align(alignment: Alignment.center, child: Text(currentEpisode.toString()))),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(Icons.add_circle_outline_outlined),
                                      onPressed: () {
                                        if (currentEpisode < snapshot.data[1]) {
                                          setState(() {
                                            currentEpisode++;
                                          });
                                        } else {
                                          setState(() {
                                            currentEpisode = 1;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 300,
                                child: CustomNumberPicker(
                                  initialValue: 1,
                                  maxValue: snapshot.data[0] as int,
                                  minValue: 1,
                                  step: 1,
                                  onValue: (value) {
                                    print(value);
                                  },
                                  customAddButton: Icon(Icons.add_circle_outline_outlined),
                                  customMinusButton: Icon(Icons.remove_circle_outline_outlined),
                                ),
                              )
                            ],
                          );
                      }
                      return Text("");
                    },
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    elevation: 0.0,
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    elevation: 5.0,
                    child: Text("Choose"),
                    onPressed: () {
                      globals.actualSelectedSeason = currentSeason;
                      globals.actualSelectedEpisode = currentEpisode;
                      setState_mainContent(() {});
                      Navigator.of(context).pop();

                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SourcePage(
                                  source: SourceSubject(
                                      tvId, tvTitle, tvOriginalTitle, true))));*/
                    },
                  )
                ]),
          );
        });
      });
}

Widget getAlertPlaceHolder(int _season, int _episode) {
  return Column(
    children: [
      Opacity(
        child: Text("Season"),
        opacity: 0.7,
      ),
      Row(
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline_outlined),
              onPressed: null,
            ),
          ),
          Expanded(
              child: Opacity(
            child: Align(alignment: Alignment.center, child: Text(_season.toString())),
            opacity: 0.7,
          )),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.add_circle_outline_outlined),
              onPressed: null,
            ),
          )
        ],
      ),
      Divider(),
      Opacity(
        child: Text("Episode"),
        opacity: 0.7,
      ),
      Row(
        children: [
          Expanded(
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline_outlined),
              onPressed: null,
            ),
          ),
          Expanded(
              child: Opacity(
            child: Align(alignment: Alignment.center, child: Text(_episode.toString())),
            opacity: 0.7,
          )),
          Expanded(
            child: IconButton(
              icon: Icon(Icons.add_circle_outline_outlined),
              onPressed: null,
            ),
          )
        ],
      ),
    ],
  );
}

Future fetchTvInfo(int id, int _season) async {
  Uri tvUrl = Uri.parse('https://api.themoviedb.org/3/tv/$id?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ');
  int tvSeasons = jsonDecode((await http.get(tvUrl)).body)["number_of_seasons"];
  var seasonsArray = jsonDecode((await http.get(tvUrl)).body)["seasons"];
  int episodeCount = 1;

  for (int i = 0; i < seasonsArray.length; i++) {
    if (seasonsArray[i]["season_number"] == _season) {
      episodeCount = seasonsArray[i]["episode_count"];
    }
  }

  return [tvSeasons, episodeCount];
}
