import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Widget getDirector(int id, bool isTV, double offset, BuildContext context) {
  if (isTV) return Container();
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Režie",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
        ),
      ),
      FutureBuilder(
        future: fetchPeopleResults(id, isTV, context, false, "Director"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Align(
                alignment: Alignment.center,
                child: LinearProgressIndicator(),
              );
            case ConnectionState.none:
              return Text("Error");
            case ConnectionState.done:
              return Container(
                  padding: EdgeInsets.only(top: offset, bottom: offset),
                  child: Container(
                    height: 60,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data[index]["image"] != null)
                            return Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(right: offset),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: snapshot.data[index]["image"] != null
                                          ? NetworkImage("https://image.tmdb.org/t/p/w200" + snapshot.data[index]["image"])
                                          : AssetImage('assets/empty_poster.jpg')),
                                ));
                          if (snapshot.data[index]["image"] == null && snapshot.data.length == 1)
                            return Container(
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.only(right: offset),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Text(
                                  snapshot.data[index]["name"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: "DINPro", color: Theme.of(context).primaryColor),
                                ),
                              ),
                            );
                          else
                            return Container();
                        }),
                  ));
          }
          return Container();
        },
      ),
    ],
  );
}

Future fetchPeopleResults(int id, bool isTV, BuildContext ctx, bool fetchActors, String department) async {
  String requestUrl = isTV
      ? "https://api.themoviedb.org/3/tv/$id/credits?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ"
      : "https://api.themoviedb.org/3/movie/$id/credits?api_key=ad5cdc02df63e67fa695781a8a3cf3fc&language=cs-CZ";

  var result = jsonDecode((await http.get(Uri.parse(requestUrl))).body);

  var people = fetchActors ? result["cast"] : result["crew"];

  var infoArray = [];

  for (var person in people) {
    if (person["known_for_department"] == department || fetchActors || !fetchActors && person["job"] == department) {
      infoArray.add({"id": person["id"], "name": person["name"], "image": person["profile_path"], "character": person["character"]});
    }
  }

  return (infoArray);
}

Widget getCast(int id, bool isTV, double offset, BuildContext context) {
  return Column(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          "Obsazení",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
        ),
      ),
      FutureBuilder(
        future: fetchPeopleResults(id, isTV, context, true, "Acting"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Align(
                alignment: Alignment.center,
                child: LinearProgressIndicator(),
              );
            case ConnectionState.none:
              return Text("Error");
            case ConnectionState.done:
              return Container(
                  padding: EdgeInsets.only(top: offset, bottom: offset),
                  child: Container(
                    height: 60,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (snapshot.data[index]["image"] != null)
                            return Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.only(right: offset),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.fitWidth,
                                      image: snapshot.data[index]["image"] != null
                                          ? NetworkImage("https://image.tmdb.org/t/p/w200" + snapshot.data[index]["image"])
                                          : AssetImage('assets/empty_poster.jpg')),
                                ));
                          if (snapshot.data[index]["image"] == null && snapshot.data.length == 1)
                            return Container(
                              width: 60,
                              height: 60,
                              margin: EdgeInsets.only(right: offset),
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                              child: Center(
                                child: Text(
                                  snapshot.data[index]["name"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: "DINPro", color: Theme.of(context).primaryColor),
                                ),
                              ),
                            );
                          else
                            return Container();
                        }),
                  ));
          }
          return Container();
        },
      ),
    ],
  );
}
