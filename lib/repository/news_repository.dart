import 'dart:developer';

import 'package:news_api_app/helpers/api_constants.dart';
import 'package:news_api_app/httpClient/http_client.dart';
import 'package:news_api_app/models/news_model.dart';

class NewsRepository {
  final HttpClient _httpClient = HttpClient();

  Future<NewsModel?> getTopHeadlines() async {
    var response = await _httpClient.get(
      url: "${ApiConstants.topHeadlinesUrl}?country=in&sortBy=popularity",
    );
    if (response.statusCode == 200) {
      log(response.body);
      return newModelFromJson(response.body);
    }
    log(response.body);
    return null;
  }

  Future<NewsModel?> searchNews({
    required String query,
    required int pageSize,
    required int page,
  }) async {
    var response = await _httpClient.get(
      url:
          "${ApiConstants.topHeadlinesUrl}?q=$query&sortBy=popularity&pageSize=$pageSize&page=$page",
    );
    if (response.statusCode == 200) {
      log(response.body);
      return newModelFromJson(response.body);
    }
    log(response.body);
    return null;
  }
}
