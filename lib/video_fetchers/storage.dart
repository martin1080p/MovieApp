import 'dart:convert';
import 'package:web_scraper/web_scraper.dart';
import 'package:video_player/video_player.dart';
import 'package:better_player/better_player.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future fetchStorageVideoSource(String url) async {
  final webScraper = WebScraper();
  if (await webScraper.loadFullURL(url)) {
    String script = webScraper.getAllScripts()[8];
    String videoLinks = script
        .substring(script.indexOf('['), script.indexOf(']') + 1)
        .replaceAll("'", '"')
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String videoString =
        videoLinks.replaceAllMapped(RegExp(r'(?<=[{[,])\s*([\w]+(?=\s*:))'), (match) {
      return '"${match.group(0)}"';
    });
    List<dynamic> videoObjects = jsonDecode(videoString);

    Map<String, String> resolutionMap =
        Map.fromIterable(videoObjects, key: (e) => e["label"], value: (e) => e["file"]);
    String initialLink = videoObjects[videoObjects.length - 1]["file"];

    String subLinks = script
        .substring(script.indexOf("[", script.indexOf("[") + 1),
            script.indexOf("]", script.indexOf("[", script.indexOf("[") + 1)) + 1)
        .replaceAll("'", '"')
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String subString = subLinks.replaceAllMapped(RegExp(r'(?<=[{[,])\s*([\w]+(?=\s*:))'), (match) {
      return '"${match.group(0)}"';
    });

    List<dynamic> subObjects = jsonDecode(subString);

    print(resolutionMap.toString());

    //return [initialLink, resolutionMap, await getAspectRatio(objects[objects.length - 1]["file"]), await isTvDevice()];
    return {
      "initial_link": initialLink,
      "resolutions": resolutionMap,
      "subtitles": subtitlesGenerator(subObjects),
      "aspect_ratio": await getAspectRatio(videoObjects[videoObjects.length - 1]["file"]),
      "is_device_tv": await isTvDevice()
    };
  }
  return "";
}

List<BetterPlayerSubtitlesSource> subtitlesGenerator(List<dynamic> subtitles) {
  List<BetterPlayerSubtitlesSource> sourceList = [];

  for (int i = 0; i < subtitles.length; i++) {
    sourceList.add(BetterPlayerSubtitlesSource(
        type: BetterPlayerSubtitlesSourceType.network,
        name: subtitles[i]['label'],
        urls: [subtitles[i]['src']]));
  }
  return sourceList;
}

Future<bool> isTvDevice() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.systemFeatures.contains('android.software.leanback_only');
}

Future<double> getAspectRatio(String videoUrl) async {
  VideoPlayerController _videoPlayerController = VideoPlayerController.network(videoUrl);
  await _videoPlayerController.initialize();
  double ratio = _videoPlayerController.value.aspectRatio;
  await _videoPlayerController.dispose();
  return ratio;
}
