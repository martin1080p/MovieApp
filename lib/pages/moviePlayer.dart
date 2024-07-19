import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class MoviePlayer extends StatefulWidget {
  const MoviePlayer({
    @required this.initialSource,
    @required this.resolutions,
    @required this.substitles,
    @required this.aspectRatio,
    @required this.isTV,
    key,
  }) : super(key: key);

  final String initialSource;
  final Map<String, String> resolutions;
  final List<dynamic> substitles;
  final double aspectRatio;
  final bool isTV;

  _MoviePlayerPlayerState createState() => _MoviePlayerPlayerState();
}

class _MoviePlayerPlayerState extends State<MoviePlayer> {
  BetterPlayerController _controller;

  @protected
  void initState() {
    super.initState();

    _controller = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: widget.aspectRatio,
        fullScreenAspectRatio: widget.aspectRatio,
        fullScreenByDefault: widget.isTV,
        fit: BoxFit.contain,
        autoPlay: true,
        looping: false,
        allowedScreenSleep: false,
        showPlaceholderUntilPlay: true,
        placeholder: Center(
          child: CircularProgressIndicator(),
        ),
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSkips: true,
          enableFullscreen: true,
          enablePlayPause: true,
          enablePlaybackSpeed: true,
          enablePip: true,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.initialSource,
        resolutions: widget.resolutions,
        subtitles: widget.substitles,
      ),
    );

    _controller.addEventsListener((BetterPlayerEvent event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Error"),
                content: Text(jsonEncode(event)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      retrySourceLoad();
                    },
                    child: Text("Retry"),
                  ),
                ],
              );
            });
      }
    });
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<dynamic> retrySourceLoad() {
    return _controller.retryDataSource();
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Expanded(
          child: Container(
            child: BetterPlayer(controller: _controller),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    ));
  }
}
