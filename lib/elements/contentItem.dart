import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:test_app/elements/contentList.dart';
import 'package:test_app/pages/sourcePage.dart';
import 'package:test_app/variables/globals.dart' as globals;

class ContentItem extends StatefulWidget {
  const ContentItem({
    Key key,
    @required this.mediaData,
    @required this.index,
    @required this.isTv,
    @required this.offset,
    @required this.height,
  }) : super(key: key);

  final Map<String, dynamic> mediaData;
  final int index;
  final bool isTv;
  final double offset;
  final double height;

  @override
  State<ContentItem> createState() => _ContentItemState();
}

class _ContentItemState extends State<ContentItem> with TickerProviderStateMixin {
  bool focused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.height * (2 / 3),
      height: widget.height,
      child: InkWell(
          onFocusChange: (val) {
            print('${widget.index.toString()}: $val');
            setState(() {
              focused = val;
            });
          },
          onTap: () {
            globals.actualSelectedEpisode = 1;
            globals.actualSelectedSeason = 1;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SourcePage(
                      source: SourceSubject(
                          widget.mediaData["id"],
                          widget.mediaData["title"],
                          widget.mediaData["original_title"],
                          widget.mediaData["image"],
                          widget.mediaData["release_year"],
                          widget.mediaData["description"],
                          widget.mediaData["vote"],
                          widget.isTv,
                          widget.offset))),
            );
          },
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            padding: focused ? EdgeInsets.zero : EdgeInsets.all(3),
            decoration: focused
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  )
                : BoxDecoration(),
            duration: Duration(milliseconds: 300),
            child: CachedNetworkImage(
              fadeInDuration: Duration.zero,
              fadeOutDuration: Duration.zero,
              imageUrl: 'https://image.tmdb.org/t/p/w342' + widget.mediaData["image"],
              placeholder: (context, url) =>
                  ShimmerItem(widget.height, Theme.of(context).primaryColor),
              //errorWidget: (context, url, error) => ContentListPlaceholder(offset, height),
            ),
          )),
    );
  }
}
