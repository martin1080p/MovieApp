import 'package:get/get.dart';
import 'package:test_app/request/api-request.dart';

class HomePageController extends GetxController{
  RxInt fragmentIndex = 0.obs;
  RxString sortParameter = "popularity".obs;
  RxString sortDirection = "desc".obs;

  //sortParameter = popularity, release_date, revenue, primary_release_date, original_title, vote_average, vote_count
  //sortDirection = desc, asc
  //mediaType = movie, show
  int pageIndex = 1;
  List<dynamic> fetchedData = [];

  bool isNextLoading = false;
  bool isNewLoading = false;

  //1 = movies
  //2 = shows

  void cleanData(){
    fetchedData = [];
  }

  Future<void> fetchNewData(int activeFragment) async{
    isNewLoading = true;
    update();

    pageIndex = 1;
    switch(activeFragment){
      case 1:
        fetchedData = await Get.find<ApiRequests>().getDiscoverMovies(
          1,
          sortParameter.value,
          sortDirection.value,
          true
        );
        break;
      case 2:
      //show
        fetchedData = await Get.find<ApiRequests>().getDiscoverShows(
          1,
          sortParameter.value,
          sortDirection.value,
          true
        );
        break;
      default:
        cleanData();
        break;
    }

    isNewLoading = false;
    update();

  }

  Future<void> fetchNextData(int activeFragment) async{

    isNextLoading = true;
    update();

    pageIndex++;
    switch(activeFragment){
      case 1:
        fetchedData.addAll(await Get.find<ApiRequests>().getDiscoverMovies(
          pageIndex,
          sortParameter.value,
          sortDirection.value,
          true
        ));
        break;
      case 2:
      //show
        fetchedData.addAll(await Get.find<ApiRequests>().getDiscoverShows(
          pageIndex,
          sortParameter.value,
          sortDirection.value,
          true
        ));
        break;
      default:
        cleanData();
        break;
    }

    isNextLoading = false;
    update();
  }
}
