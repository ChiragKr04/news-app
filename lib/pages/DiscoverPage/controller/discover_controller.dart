import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/helpers/constant_enums.dart';
import 'package:news_api_app/models/news_model.dart';
import 'package:news_api_app/repository/news_repository.dart';

class DiscoverController {
  Rx<NewsCategory> searchQuery = Rx<NewsCategory>(NewsCategory.all);

  List<NewsCategory> allQueries = [...NewsCategory.values];
  final NewsRepository _newsRepository = NewsRepository();
  RxBool isLoading = false.obs;
  Rxn<NewsModel> newsData = Rxn<NewsModel>();
  TextEditingController searchController = TextEditingController();

  void init() {
    _fetchNewsOnQueryChange(
      query: searchQuery.value.name,
    );
  }

  void getNewsData(NewsCategory allQueri) {
    if (searchQuery.value == allQueri) return;
    searchQuery.value = allQueri;
    _fetchNewsOnQueryChange(
      query: searchQuery.value.name,
    );
  }

  void searchNews() {
    if (searchQuery.value == NewsCategory.all) return;
    _fetchNewsOnQueryChange(
      query: searchController.text.trim(),
    );
  }

  Future<void> _fetchNewsOnQueryChange({
    required String query,
  }) async {
    isLoading.value = true;
    newsData.value = await _newsRepository.searchNews(
      query: query,
      pageSize: 20,
      page: 1,
    );
    isLoading.value = false;
  }
}
