import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiRequests {
  String defaultApiKey = "ad5cdc02df63e67fa695781a8a3cf3fc";
  String defaultLang = "cs-CZ";

  String apiKey;
  String lang;

  ApiRequests({String apiKey, String lang}) {
    apiKey != null ? this.apiKey = apiKey : this.apiKey = defaultApiKey;
    lang != null ? this.lang = lang : this.lang = defaultLang;
  }

  Future<List<dynamic>> getDiscoverMovies(String region, int page, String sortParameter,
      String sortDirection, int minimumVoteCount, bool nonImages) async {
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=$lang&page=$page&sort_by=$sortParameter.$sortDirection&include_adult=false&include_video=false&vote_count.gte=$minimumVoteCount&region=$region",
        nonImages);
  }

  Future<List<dynamic>> getDiscoverShows(String region, int page, String sortParameter,
      String sortDirection, int minimumVoteCount, bool nonImages) async {
    //SortParameter = popularity, release_date, revenue, primary_release_date, original_title, vote_average, vote_count
    //SortDirection = desc, asc
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&language=$lang&page=$page&sort_by=$sortParameter.$sortDirection&include_adult=false&include_video=false&vote_count.gte=$minimumVoteCount&region=$region",
        nonImages);
  }

  Future<List<dynamic>> getWeekAirShows(String region, int page, bool nonImages) async {
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/tv/on_the_air?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getWeekAirMovies(String region, int page, bool nonImages) async {
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=$lang&page=$page&region=$region",
        nonImages);
  }

  Future<List<dynamic>> getTopShows(String region, int page, bool nonImages) async {
    //region: CZ
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/tv/top_rated?api_key=$apiKey&language=$lang&page=$page&region=$region",
        nonImages);
  }

  Future<List<dynamic>> getTopMovies(String region, int page, bool nonImages) async {
    //region: CZ
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=$lang&page=$page&region=$region",
        nonImages);
  }

  Future<List<dynamic>> getTendingShows(String time, int page, bool nonImages) async {
    //time: day, week
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/trending/tv/day?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getTendingMovies(String time, int page, bool nonImages) async {
    //time: day, week
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getSearchShows(String query, String year, int page, bool nonImages) async {
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/search/tv?api_key=$apiKey&language=$lang&page=$page&query=$query&include_adult=false&first_air_date_year=${year.toString()}",
        nonImages);
  }

  Future<List<dynamic>> getSearchMovies(String query, String year, int page, bool nonImages) async {
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=$lang&query=$query&page=$page&include_adult=false&primary_release_year=${year.toString()}",
        nonImages);
  }

  Future<List<dynamic>> getSimilarShows(int id, int page, bool nonImages) async {
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/tv/$id/similar?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getSimilarMovies(int id, int page, bool nonImages) async {
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/movie/$id/similar?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getPopularShows(int page, bool nonImages) async {
    return await receiveShowInfo(
        "https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<List<dynamic>> getPopularMovies(int page, bool nonImages) async {
    return await receiveMovieInfo(
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=$lang&page=$page",
        nonImages);
  }

  Future<int> getMoviePremiereYear(int id) async {
    Uri link = Uri.parse('https://api.themoviedb.org/3/movie/$id/release_dates?api_key=$apiKey');
    var response = jsonDecode((await http.get(link)).body);

    int minYear = 9999;

    for (var i = 0; i < response["results"].length; i++) {
      for (var j = 0; j < response["results"][i]["release_dates"].length; j++) {
        int year = DateTime.parse(response["results"][i]["release_dates"][j]["release_date"]).year;
        if (year < minYear) {
          minYear = year;
        }
      }
    }

    return minYear;
  }
}

Future<List<dynamic>> receiveShowInfo(String url, bool includeNonImages) async {
  Uri link = Uri.parse(url);
  var results = jsonDecode((await http.get(link)).body)["results"];
  var infos = [];

  for (var i = 0; i < results.length; i++) {
    if (results[i]["poster_path"] == null && !includeNonImages) break;

    infos.add({
      "title": results[i]["name"],
      "original_title": results[i]["original_name"],
      "id": results[i]["id"],
      "image": results[i]["poster_path"],
      "vote": results[i]["vote_average"].toDouble(),
      "description": results[i]["overview"],
      "release_year": (results[i]["first_air_date"] != "" && results[i]["first_air_date"] != null)
          ? DateTime.parse(results[i]["first_air_date"]).year.toString()
          : ""
    });
  }

  return infos;
}

Future<List<dynamic>> receiveMovieInfo(String url, bool includeNonImages) async {
  Uri link = Uri.parse(url);
  var results = jsonDecode((await http.get(link)).body)["results"];
  var infos = [];

  for (var i = 0; i < results.length; i++) {
    if (results[i]["poster_path"] == null && !includeNonImages) break;

    infos.add({
      "title": results[i]["title"],
      "original_title": results[i]["original_title"],
      "id": results[i]["id"],
      "image": results[i]["poster_path"],
      "vote": results[i]["vote_average"].toDouble(),
      "description": results[i]["overview"],
      "release_year": (results[i]["release_date"] != "" && results[i]["release_date"] != null)
          ? DateTime.parse(results[i]["release_date"]).year.toString()
          : ""
    });
  }

  return infos;
}
