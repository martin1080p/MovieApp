import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:test_app/elements/roundedContainer.dart';

class FourthFragment extends StatelessWidget {
  final int maxStorageCount = 20;

  @override
  Widget build(BuildContext context) {
    List<dynamic> storageArray = GetStorage().read('watched_list');
    List<Widget> widgetArray = [];

    if (storageArray.length > maxStorageCount) {
      storageArray = storageArray.sublist(0, maxStorageCount);
      GetStorage().write('watched_list', storageArray);
    }

    if (storageArray != null)
      for (int i = 0; i < storageArray.length; i++) {
        widgetArray.add(RoundedContainer(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage('https://image.tmdb.org/t/p/w500${storageArray[i]["image"]}')),
              title: Text(
                storageArray[i]["title"] +
                    (storageArray[i]["is_tv"]
                        ? " ${storageArray[i]["season"].toString().padLeft(2, "0")}x${storageArray[i]["episode"].toString().padLeft(2, "0")}"
                        : ""),
                maxLines: 1,
              ),
              subtitle: Text(
                storageArray[i]["description"],
                maxLines: 2,
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(storageArray[i]["time_now"]),
                  Text(storageArray[i]["date_now"]),
                ],
              ),
            ),
          ),
        ));
      }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Column(children: widgetArray.length != 0 ? widgetArray : [Text("null")]),
      ),
    );
  }
}
