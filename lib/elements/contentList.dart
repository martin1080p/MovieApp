import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/request/api-request.dart';
import 'package:test_app/pages/sourcePage.dart';


class ContentList extends StatelessWidget {
  final List<dynamic> mediaDatas;
  final double offset;
  final bool isTv;
  const ContentList(List<dynamic> mediaDatas, double offset, bool isTv, {Key key}) : this.mediaDatas = mediaDatas, this.offset = offset, this.isTv = isTv, super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mediaDatas.length,
        itemBuilder: (BuildContext context,int i) {
          return InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SourcePage(
                        source: SourceSubject(
                          mediaDatas[i]["id"],
                          mediaDatas[i]["title"],
                          mediaDatas[i]["original_title"],
                          mediaDatas[i]["image"],
                          mediaDatas[i]["release_year"],
                          mediaDatas[i]["description"],
                          mediaDatas[i]["vote"],
                          isTv,
                          offset))),
              );
            },
            child: Container(
              child: Image.network(
                'https://image.tmdb.org/t/p/w500' + mediaDatas[i]["image"]
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index){
          return Container(
            width: offset / 2,
          );
        },
      ),
    );
  }
}

class TopMoviesList extends StatelessWidget {
  final String region;
  final double height;
  final double offset;

  const TopMoviesList({@required String region, double height, double offset, Key key}) : this.region = region, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getTopMovies(region, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nejlépe hodnocené filmy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, false),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

class TopShowsList extends StatelessWidget {
  final String region;
  final double height;
  final double offset;

  const TopShowsList({@required String region, double height, double offset, Key key}) : this.region = region, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getTopShows(region, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nejlépe hodnocené seriály",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, true),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

class TrendingMoviesList extends StatelessWidget {
  final String interval;
  final double height;
  final double offset;

  const TrendingMoviesList({@required String interval, double height, double offset, Key key}) : this.interval = interval, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getTendingMovies(interval, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Populární filmy dnes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, false),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

class TrendingShowsList extends StatelessWidget {
  final String interval;
  final double height;
  final double offset;

  const TrendingShowsList({@required String interval, double height, double offset, Key key}) : this.interval = interval, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getTendingShows(interval, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Populární seriály dnes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, true),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

class SimilarMoviesList extends StatelessWidget {
  final int id;
  final double height;
  final double offset;

  const SimilarMoviesList(int id, double height, double offset, {Key key}) : this.id = id, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getSimilarMovies(id, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Podobné filmy",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, false),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

class SimilarShowsList extends StatelessWidget {
  final int id;
  final double height;
  final double offset;
  
  const SimilarShowsList(int id, double height, double offset, {Key key}) : this.id = id, this.height = height, this.offset = offset, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: ApiRequests().getSimilarShows(id, 1, false),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Podobné seriály",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                ),
                Container(
                  height: height,
                  margin: EdgeInsets.only(top: offset),
                  child: ContentList(snapshot.data, offset, true),
                ),
              ],
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
}

