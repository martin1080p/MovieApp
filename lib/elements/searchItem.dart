import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/pages/sourcePage.dart';
import 'package:test_app/variables/globals.dart' as globals;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget getSearchItem(BuildContext context, int _mediaId, String _mediaTitle, String _mediaOriginalTitle, String _mediaImageUrl,
    String _mediaReleaseYear, String _mediaDescription, double _mediaVote, bool _isTV) {
  double _offset = 20.0;
  double _screenWidth = MediaQuery.of(context).size.width;
  double _imageWidth = _screenWidth * 0.3;
  double _imageHeight = _imageWidth / 9 * 16 - 2 * _offset;

  return InkWell(
    onTap: () {
      globals.actualSelectedEpisode = 1;
      globals.actualSelectedSeason = 1;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SourcePage(
                source: SourceSubject(_mediaId, _mediaTitle, _mediaOriginalTitle, _mediaImageUrl, _mediaReleaseYear, _mediaDescription,
                    _mediaVote, _isTV, _offset))),
      );
    },
    child: Container(
      child: Stack(alignment: AlignmentDirectional.bottomStart, children: [
        Center(
          child: Container(
            width: _screenWidth - _offset,
            padding: EdgeInsets.fromLTRB(0, 0, _offset, 0),
            height: _imageHeight,
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.all(Radius.circular(6.0))),
            child: Row(children: <Widget>[
              Container(
                width: _imageWidth + _offset * 2,
                //child: _movieImage,
              ),
              Container(
                child: Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
                    Align(
                      child: Text(
                        _mediaTitle + _mediaReleaseYear,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                        overflow: TextOverflow.ellipsis,
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    Opacity(
                      child: Text(
                        _mediaDescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: "DINPro"),
                      ),
                      opacity: 0.5,
                    ),
                    Row(
                      children: [
                        Text(
                          _mediaVote.toString() + " ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "DINPro", color: Colors.amber),
                        ),
                        RatingBarIndicator(
                          rating: _mediaVote / 2,
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
                    )
                  ]),
                ),
              )
            ]),
          ),
        ),
        Container(
            child: Hero(
                tag: "image" + _mediaId.toString(),
                child: _mediaImageUrl != null
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/empty_poster.jpg', image: 'https://image.tmdb.org/t/p/w500$_mediaImageUrl', width: _imageWidth)
                    : Container(
                        width: _imageWidth,
                        height: _imageHeight,
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      )
                /*Image(
                width: _imageWidth,
                image: _mediaImageUrl != null
                    ? FadeInImage.assetNetwork(placeholder: 'assets/empty_poster.jpg', image: 'https://image.tmdb.org/t/p/w500" + _mediaImageUrl')//NetworkImage("https://image.tmdb.org/t/p/w500" + _mediaImageUrl)
                    : AssetImage('assets/empty_poster.jpg')),*/
                ),
            //margin: EdgeInsets.all(_imageOffset),
            margin: EdgeInsets.fromLTRB(_offset * 1.5, _offset, _offset, _offset)),
      ]),
    ),
  );
}
