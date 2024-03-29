import 'package:flutter/material.dart';
import 'package:test_app/elements/contentList.dart';
import 'package:test_app/elements/roundedContainer.dart';

class FirstFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _offset = 20.0;
    //double _screenWidth = MediaQuery.of(context).size.width;
    double _screenHeight = MediaQuery.of(context).size.height;

    Widget _divider = Divider(
      height: 0,
      thickness: 2,
    );

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        //height: _screenHeight/ 4,
        child: Container(
          padding: EdgeInsets.only(top: _offset / 2),
          child: RoundedContainer(
            margin: EdgeInsets.fromLTRB(_offset / 2, 0, _offset / 2, _offset / 2),
            padding: EdgeInsets.fromLTRB(_offset / 2, _offset, _offset / 2, _offset / 2),
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: _offset),
                      child: TrendingMoviesList(
                        interval: "day",
                        offset: _offset,
                        height: _screenHeight / 4,
                        moreButton: true,
                      ),
                    ),
                    _divider,
                    Container(
                      margin: EdgeInsets.only(top: _offset, bottom: _offset),
                      child: TrendingShowsList(
                        interval: "day",
                        offset: _offset,
                        height: _screenHeight / 4,
                        moreButton: true,
                      ),
                    ),
                    _divider,
                    Container(
                        margin: EdgeInsets.only(top: _offset, bottom: _offset),
                        child: TopMoviesList(
                          region: "cz",
                          offset: _offset,
                          height: _screenHeight / 4,
                          moreButton: true,
                        )),
                    _divider,
                    Container(
                        margin: EdgeInsets.only(top: _offset, bottom: _offset),
                        child: TopShowsList(
                          region: "cz",
                          offset: _offset,
                          height: _screenHeight / 4,
                          moreButton: true,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
