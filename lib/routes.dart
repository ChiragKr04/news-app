import 'package:flutter/material.dart';
import 'package:news_api_app/pages/home_wrapper.dart';
import 'package:news_api_app/pages/LoginPage/login_page.dart';
import 'package:news_api_app/pages/NewInfoPage/news_info_page.dart';
import 'package:news_api_app/pages/SearchViewPage/search_view_page.dart';
import 'package:news_api_app/pages/WebNews/web_news.dart';

class CustomRoutes {
  static const String homeWrapper = '/homeWrapper';
  static const String newsInfoPage = '/newsInfo';
  static const String searchViewPage = '/searchView';
  static const String loginPage = '/login';
  static const String webNews = '/webNews';

  static String get initialRoute => loginPage;

  static Map<String, Widget Function(BuildContext)> routes = {
    loginPage: (context) => const LoginPage(),
    homeWrapper: (context) => const HomeWrapper(),
    newsInfoPage: (context) => const NewsInfoPage(),
    searchViewPage: (context) => const SearchViewPage(),
    webNews: (context) => const WebNews(),
  };
}
