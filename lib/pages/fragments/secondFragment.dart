import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/controllers/homepage_controller.dart';
import 'package:test_app/elements/roundedContainer.dart';
import 'package:test_app/pages/sourcePage.dart';

// ignore: must_be_immutable
class SecondFragment extends StatefulWidget {

  @override
  State<SecondFragment> createState() => _SecondFragmentState();
}

class _SecondFragmentState extends State<SecondFragment> {

  HomePageController homeController = Get.find<HomePageController>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if(scrollController.position.pixels == scrollController.position.maxScrollExtent){
        homeController.fetchNextData(1);
      }
    });
    homeController.sortDirection.value = "desc";
    homeController.sortParameter.value = "popularity";
  }

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor, borderRadius: BorderRadius.only(bottomRight: Radius.circular(20.0))),
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Filmy",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ),
                GetX<HomePageController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        DropdownButton(
                          value: controller.sortParameter.value,
                          onChanged: (val){
                            controller.sortParameter.value = val;
                            controller.fetchNewData(1);
                          },
                          items: [
                            DropdownMenuItem(
                              value: "popularity",
                              child: Row(
                                children: [
                                  Icon(Icons.whatshot),
                                  Text(" Žhavé")
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "vote_average",
                              child: Row(
                                children: [
                                  Icon(Icons.favorite_rounded),
                                  Text(" Oblíbené"),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: "original_title",
                              child: Row(
                                children: [
                                  Icon(Icons.sort_by_alpha_rounded),
                                  Text(" Abecedně")
                                ],
                              ),
                            ),
                          ],
                        ),controller.sortDirection.value == "asc" ?
                            IconButton(
                              icon: Icon(
                                Icons.arrow_downward_rounded
                              ),
                              onPressed: (){
                                controller.sortDirection.value = "desc";
                                controller.fetchNewData(1);
                              },
                            ):
                            IconButton(
                              icon: Icon(
                                Icons.arrow_upward_rounded
                              ),
                              onPressed: (){
                                controller.sortDirection.value = "asc";
                                controller.fetchNewData(1);
                              },
                            )
                      ],
                    );
                  }
                ),
              ],
            ),
            GetBuilder<HomePageController>(
              builder: (controller){
                    return Expanded(
                      child: 
                      controller.isNewLoading ?
                      Center(
                        child: CircularProgressIndicator(),
                      ):
                      LayoutBuilder(
                        builder:(context, constraints){
                          return Column(
                            children: [
                              Container(
                                height: constraints.maxHeight - 4,
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: GridView.builder(
                                  controller: scrollController,
                                  itemCount: controller.fetchedData.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 3,
                                    childAspectRatio: 500 / 850
                                  ),
                                  itemBuilder:(context, index) {
                                    List<dynamic> data = controller.fetchedData;
                                    return InkWell(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SourcePage(
                                                  source: SourceSubject(
                                                    data[index]["id"],
                                                    data[index]["title"],
                                                    data[index]["original_title"],
                                                    data[index]["image"],
                                                    data[index]["release_year"],
                                                    data[index]["description"],
                                                    data[index]["vote"],
                                                    false,
                                                    20.0))),
                                        );
                                      },
                                      child: Column(
                                      children: [
                                        Builder(
                                          builder: (context) {
                                              return Expanded(
                                                child: AspectRatio(
                                                  aspectRatio: 500/708,
                                                  child: 
                                                  Hero(
                                                    tag: "image" + data[index]["id"].toString(),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context).cardColor,
                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
                                                        ),
                                                        child: data[index]["image"] != null ?
                                                        CachedNetworkImage(
                                                          imageUrl: "https://image.tmdb.org/t/p/w500" + data[index]["image"],
                                                          imageBuilder: (BuildContext context, ImageProvider imageProvider){
                                                            return Container(
                                                              decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: imageProvider,
                                                                    fit: BoxFit.fill,
                                                                )
                                                            )
                                                            );
                                                          },
                                                        ):
                                                        Container()
                                                      ),
                                                  )
                                              ));
                                          }
                                        ),
                                          RoundedContainer(
                                            padding: EdgeInsets.only(left: 8.0),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0.0),
                                              topRight: Radius.circular(0.0),
                                              bottomLeft: Radius.circular(8.0),
                                              bottomRight: Radius.circular(8.0)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data[index]["title"],
                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "DINPro"),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  data[index]["release_year"],
                                                  style: TextStyle(
                                                    fontSize: 11
                                                  ),
                                                )
                                              ],
                                            )
                                            
                                          )
                                      ]
                                      ),
                                    );
                                  }
                                ),
                              ),
                              controller.isNextLoading ?
                              Center(
                                child: LinearProgressIndicator(),
                              ):
                              Container()
                            ],
                          );
                        }
                      ),
                    );
            })
          ],
        ),
      ),
    );
  }
}