import 'dart:convert';

import 'package:news_app/Model_Worldwide.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/Pk_Model';
import 'package:news_app/aus_model';
import 'package:news_app/india_model.dart';
import 'package:news_app/uk_model.dart';

class ApiBbc {
  String Url =
      "https://newsapi.org/v2/top-headlines?sources=bbc-news,cnn,fox-news,reuters,financial-times,al-jazeera-english&pageSize=100&apiKey=7ab878580efe4a7a96bf8cbf2e84b929";
  Future<Model_Worldwide> callapi() async {
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      return Model_Worldwide.fromJson(data);
    } else {
      throw Exception("Error in fetching api");
    }
  }
}

class fetchApi {
  Future<dynamic> fetchnews(String coun, {String? category}) async {
    String url = "";
    switch (coun.toLowerCase()) {
      case "pk":
        url =
            "https://gnews.io/api/v4/top-headlines?country=$coun&lang=en&max=100&apikey=5cf3227fdbe263a9418fba2521b3511f";
        break;
      case "in":
        url =
            "https://gnews.io/api/v4/top-headlines?country=$coun&lang=en&max=100&apikey=5cf3227fdbe263a9418fba2521b3511f";
        break;
      case "gb":
        url =
            "https://gnews.io/api/v4/top-headlines?country=$coun&lang=en&max=100&apikey=5cf3227fdbe263a9418fba2521b3511f";
        break;
      case "au":
        url =
            "https://gnews.io/api/v4/top-headlines?country=$coun&lang=en&max=100&apikey=5cf3227fdbe263a9418fba2521b3511f";
        break;
    }
    if (category != null && category.isNotEmpty) {
      url += "&topic=$category";
    }
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      switch (coun.toLowerCase()) {
        case "pk":
          return Pk_Model.fromJson(data);
        case "in":
          return India_Model.fromJson(data);
        case "gb":
          return Uk_Model.fromJson(data);
        case "au":
          return Aus_Model.fromJson(data);
      }
    } else {
      throw Exception("Error in fetching api");
    }
  }
}
