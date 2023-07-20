import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/pages/HomePage/controller/home_controller.dart';
import 'package:news_api_app/pages/components/article_item.dart';
import 'package:news_api_app/pages/components/custom_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController viewController = HomeController();

  @override
  void initState() {
    super.initState();
    viewController.getNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: Obx(
        () {
          if (viewController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (viewController.newsData.value == null) {
            return const Center(
              child: Text("No News Found"),
            );
          }
          if (viewController.newsData.value != null &&
              viewController.newsData.value!.articles.isEmpty) {
            return const Center(
              child: Text("No News Found"),
            );
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Breaking News',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomCarousel(
                  articles: viewController.newsData.value!.articles.sublist(
                    0,
                    5,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16,
                  ),
                  child: Text(
                    "Recommendation",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...List.generate(
                  10,
                  (index) {
                    Article currentArticle =
                        viewController.newsData.value!.articles[index + 5];
                    return ArticleItem(currentArticle: currentArticle);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
