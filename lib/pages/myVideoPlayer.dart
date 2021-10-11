import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/video_fetchers/storage.dart';
import 'package:better_player/better_player.dart';
import 'package:test_app/variables/globals.dart' as globals;

class MyVideoPlayer extends StatefulWidget {
  MyVideoPlayer({Key key}) : super(key: key);

  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  BetterPlayerController _controller;

  @protected
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchStorageVideoSource(globals.activeLink),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _controller = BetterPlayerController(
              BetterPlayerConfiguration(
                  aspectRatio: snapshot.data["aspect_ratio"],
                  fullScreenAspectRatio: snapshot.data["aspect_ratio"],
                  fullScreenByDefault: snapshot.data["is_device_tv"],
                  fit: BoxFit.contain,
                  autoPlay: true,
                  looping: false,
                  allowedScreenSleep: false,
                  showPlaceholderUntilPlay: true,
                  placeholder: Center(
                    child: CircularProgressIndicator(),
                  ),
                  controlsConfiguration: BetterPlayerControlsConfiguration(
                      enableSkips: false, enableFullscreen: true, enablePlayPause: true, enablePlaybackSpeed: true, enablePip: true)),
              betterPlayerDataSource:
                  BetterPlayerDataSource(
                    BetterPlayerDataSourceType.network,
                    snapshot.data["initial_link"],
                    resolutions: snapshot.data["resolutions"],
                    subtitles: snapshot.data["subtitles"]
                  )
              );
          return Container(
              child: Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Container(child: BetterPlayer(controller: _controller)),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
