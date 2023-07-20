import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/helpers/helpers.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/repository/news_repository.dart';

class SearchViewController {
  Rx<String> searchQuery = Rx<String>("");

  final NewsRepository _newsRepository = NewsRepository();
  RxList<Article> articles = RxList<Article>([]);
  int page = 1;
  final RxBool _isSearching = false.obs;
  bool get isSearching => _isSearching.value;
  final RxBool _hasReachedEnd = false.obs;
  bool get hasReachedEnd => _hasReachedEnd.value;
  ScrollController scrollController = ScrollController();

  void init({
    required String query,
  }) {
    searchQuery.value = query;
    _fetchNewsOnQueryChange(
      query: searchQuery.value,
    );
    _listenOnScroll();
  }

  /// For infinite Scroll
  void _listenOnScroll() {
    /// Function to fetch more news when user reaches at the bottom of the list
    scrollController.onBottomReach(() {
      _fetchNewsOnQueryChange(
        query: searchQuery.value,
      );
    });
  }

  Future<void> _fetchNewsOnQueryChange({
    required String query,
  }) async {
    if (_isSearching.value || _hasReachedEnd.value) return;
    _isSearching.value = true;
    var data = await _newsRepository.searchNews(
      query: query,
      pageSize: 20,
      page: page,
    );
    page++;
    articles.addAll(data?.articles ?? []);
    if (data != null && data.articles.isEmpty) _hasReachedEnd.value = true;
    _isSearching.value = false;
  }
}
