import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_app/controllers/homepage_controller.dart';
import 'package:test_app/request/api-request.dart';
import 'package:test_app/pages/sourcePage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';


// ignore: must_be_immutable
class ContentList extends StatelessWidget {
  final List<dynamic> mediaDatas;
  final double offset;
  final double height;
  final bool isTv;
  final bool moreButton;
  final int fragmentIndex;
  final String sortParameter;

  ContentList(List<dynamic> mediaDatas, double offset, double height, bool isTv, bool moreButton, int fragmentIndex, String sortParameter, {Key key}) : this.mediaDatas = mediaDatas, this.offset = offset, this.height = height, this.isTv = isTv, this.moreButton = moreButton, this.fragmentIndex = fragmentIndex, this.sortParameter = sortParameter, super(key: key);

  HomePageController homeController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: mediaDatas.length,
        itemBuilder: (BuildContext context,int i) {
          return Row(
            children: [
              InkWell(
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
                child: CachedNetworkImage(
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  imageUrl: 'https://image.tmdb.org/t/p/w500' + mediaDatas[i]["image"],
                  placeholder: (context, url) => ShimmerItem(height, Theme.of(context).primaryColor),
                  //errorWidget: (context, url, error) => ContentListPlaceholder(offset, height),
                ),
                /*
                child: Container(
                  child: Image.network(
                    
                  ),
                ),*/
              ),
              moreButton && i == mediaDatas.length-1 ? 
              InkWell(
                onTap: (){
                  homeController.sortParameter.value = sortParameter;
                  homeController.sortDirection.value = "desc";
                  homeController.fragmentIndex.value = fragmentIndex;
                  homeController.fetchNewData(fragmentIndex);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(offset / 2, offset / 4, offset / 2, offset / 4),
                  padding: EdgeInsets.all(offset / 2),
                  child: Center(child: Text("Více")),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8.0))
                  ),  
                ),
              ) :
              Container()
            ],
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
  final bool moreButton;

  TopMoviesList({@required String region, double height, double offset, bool moreButton, Key key}) : this.region = region, this.height = height, this.offset = offset, this.moreButton = moreButton, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Nejlépe hodnocené filmy",
            fragmentIndex: 1,
            sortParameter: "vote_average",
            hasButton: true,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getTopMovies(region, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, false, moreButton, 1, "vote_average");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
      )
    );
  }
}

class TopShowsList extends StatelessWidget {
  final String region;
  final double height;
  final double offset;
  final bool moreButton;

  const TopShowsList({@required String region, double height, double offset, bool moreButton, Key key}) : this.region = region, this.height = height, this.offset = offset, this.moreButton = moreButton, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Nejlépe hodnocené seriály",
            fragmentIndex: 2,
            sortParameter: "vote_average",
            hasButton: true,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getTopShows(region, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, true, moreButton, 2, "vote_average");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
      )
    );
  }
}

class TrendingMoviesList extends StatelessWidget {
  final String interval;
  final double height;
  final double offset;
  final bool moreButton;

  const TrendingMoviesList({@required String interval, double height, double offset, bool moreButton, Key key}) : this.interval = interval, this.height = height, this.offset = offset, this.moreButton = moreButton, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Populární filmy dnes",
            fragmentIndex: 1,
            sortParameter: "popularity",
            hasButton: true,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getTendingMovies(interval, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, false, moreButton, 1, "popularity");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
      )
    );
  }
}

class TrendingShowsList extends StatelessWidget {
  final String interval;
  final double height;
  final double offset;
  final bool moreButton;

  const TrendingShowsList({@required String interval, double height, double offset, bool moreButton, Key key}) : this.interval = interval, this.height = height, this.offset = offset, this.moreButton = moreButton, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Populární seriály dnes",
            fragmentIndex: 2,
            sortParameter: "popularity",
            hasButton: true,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getTendingShows(interval, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, true, moreButton, 2, "popularity");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Podobné filmy",
            hasButton: false,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getSimilarMovies(id, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, false, false, 0, "");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTitle(
            title: "Podobné seriály",
            hasButton: false,
          ),
          Container(
            height: height,
            margin: EdgeInsets.only(top: offset),
            child: FutureBuilder(
              future: Get.find<ApiRequests>().getSimilarShows(id, 1, false),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  return ContentList(snapshot.data, offset, height, true, false, 0, "");
                }
                return ContentListPlaceholder(offset, height);
              },
            ),
          ),
        ],
      )
    );
  }
}

class ContentListPlaceholder extends StatelessWidget {
  final double offset;
  final double height;
  const ContentListPlaceholder(double offset, double height, {Key key}) : this.offset = offset, this.height = height, super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        itemBuilder: (BuildContext context,int i) {
          return ShimmerItem(
            height,
            Theme.of(context).primaryColor
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


// ignore: must_be_immutable
class ShimmerItem extends StatelessWidget{

  double height;
  Color color;

  ShimmerItem(double height, Color color, {Key key}) : this.height = height, this.color = color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
            period: Duration(milliseconds: 1000),
            baseColor: Colors.grey.shade700.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.2),
            child: Container(
              width: height * 500 / 708 - 6,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(4.0))
              ),
            ),
          );
  }
}

// ignore: must_be_immutable
class ListTitle extends StatelessWidget {


  String title;
  int fragmentIndex;
  String sortParameter;
  bool hasButton;

  ListTitle({
    Key key,
    @required this.title,
    this.fragmentIndex,
    this.sortParameter,
    @required this.hasButton
  }) : super(key: key);

  HomePageController homeController = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {

    fragmentIndex ??= homeController.fragmentIndex.value;
    sortParameter ??= homeController.sortParameter.value;

    return InkWell(
      enableFeedback: hasButton,
      onTap: (){
        if(hasButton){
          homeController.sortParameter.value = sortParameter;
          homeController.sortDirection.value = "desc";
          homeController.fragmentIndex.value = fragmentIndex;
          homeController.fetchNewData(fragmentIndex);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
          ),
          hasButton ?
          Icon(
            Icons.arrow_forward_ios_rounded
          ):
          Container()
        ],
      ),
    );
  }
}



