import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_app/variables/globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;

episodeSelection(
    // ignore: non_constant_identifier_names
    BuildContext context, int tvId, Function setState_mainContent) async {
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
                title: Text("Výběr epizody"),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(children: [
                            Text("Sezóna"),
                            Container(child: StatefulBuilder(
                              builder: (BuildContext context, void Function(void Function()) setState) {
                                currentEpisode = 1;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove_rounded),
                                          onPressed: () {
                                            setState(() {
                                              if(currentSeason == 1)
                                                currentSeason = globals.actualMaximumSeasons;
                                              else
                                                currentSeason--;
                                            });
                                          },
                                        ),
                                        Text(currentSeason.toString()),
                                        IconButton(
                                          icon: Icon(Icons.add_rounded),
                                          onPressed: () {
                                            setState(() {
                                              if(currentSeason == globals.actualMaximumSeasons)
                                                currentSeason = 1;
                                              else
                                                currentSeason++;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Text("Epizoda"),
                                    FutureBuilder(
                                      future: fetchTvInfo(tvId, currentSeason),
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        if (snapshot.connectionState == ConnectionState.done) {
                                          int maxEpisode = snapshot.data["current_season_episodes_count"];
                                          globals.actualMaximumSeasons = snapshot.data["total_seasons_count"];

                                          return Container(
                                            child: StatefulBuilder(
                                              builder: (BuildContext context,
                                                  void Function(void Function())
                                                      setState) {
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.remove_rounded),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (currentEpisode == 1)
                                                            currentEpisode = maxEpisode;
                                                          else
                                                            currentEpisode--;
                                                        });
                                                      },
                                                    ),
                                                    Text(currentEpisode
                                                        .toString()),
                                                    IconButton(
                                                      icon: Icon(
                                                          Icons.add_rounded),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (currentEpisode == maxEpisode)
                                                            currentEpisode = 1;
                                                          else
                                                            currentEpisode++;
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            )),
                          ])
                ),
                actions: <Widget>[
                  MaterialButton(
                    elevation: 0.0,
                    child: Text("Zrušit"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    elevation: 5.0,
                    child: Text("Vybrat"),
                    onPressed: () {
                      globals.actualSelectedSeason = currentSeason;
                      globals.actualSelectedEpisode = currentEpisode;
                      setState_mainContent(() {});
                      Navigator.of(context).pop();

                    },
                  )
                ]),
          );
        });
      });
}



Future<Map<String, int>> fetchTvInfo(int id, int _season) async {
  Uri tvUrl = Uri.parse(
      'https://api.themoviedb.org/3/tv/$id?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ');
  int seasonsCount =
      jsonDecode((await http.get(tvUrl)).body)["number_of_seasons"];
  var seasonsArray = jsonDecode((await http.get(tvUrl)).body)["seasons"];
  int episodeCountOfCurrentSeason = 1;

  for (int i = 0; i < seasonsArray.length; i++) {
    if (seasonsArray[i]["season_number"] == _season) {
      episodeCountOfCurrentSeason = seasonsArray[i]["episode_count"];
    }
  }

  return {
    "total_seasons_count": max(seasonsCount, 1),
    "current_season_episodes_count": episodeCountOfCurrentSeason
  };
}
