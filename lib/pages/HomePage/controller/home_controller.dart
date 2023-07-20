import 'package:get/get.dart';
import 'package:news_api_app/models/news_model.dart';
import 'package:news_api_app/repository/news_repository.dart';

class HomeController {
  Rxn<NewsModel> newsData = Rxn<NewsModel>();
  final NewsRepository _newsRepository = NewsRepository();
  RxBool isLoading = false.obs;

  void getNewsData() async {
    isLoading.value = true;
    var newsModel = await _newsRepository.getTopHeadlines();
    newsData.value = newsModel;
    isLoading.value = false;
  }
}
