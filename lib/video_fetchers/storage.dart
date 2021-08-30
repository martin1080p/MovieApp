import 'dart:convert';
import 'package:web_scraper/web_scraper.dart';
import 'package:video_player/video_player.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future fetchStorageVideoSource(String url) async {
  final webScraper = WebScraper();
  if (await webScraper.loadFullURL(url)) {
    String script = webScraper.getAllScripts()[8];
    String links = script
        .substring(script.indexOf('['), script.indexOf(']') + 1)
        .replaceAll("'", '"')
        .replaceAll(new RegExp(r"\s+\b|\b\s"), "");
    String newString = links.replaceAllMapped(RegExp(r'(?<=[{[,])\s*([\w]+(?=\s*:))'), (match) {
      return '"${match.group(0)}"';
    });
    List<dynamic> objects = jsonDecode(newString);

    Map<String, String> resolutionMap = Map.fromIterable(objects, key: (e) => e["label"], value: (e) => e["file"]);
    String initialLink = objects[objects.length - 1]["file"];

    print(resolutionMap.toString());

    return [initialLink, resolutionMap, await getAspectRatio(objects[objects.length - 1]["file"]), await isTvDevice()];
  }
  return "";
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
