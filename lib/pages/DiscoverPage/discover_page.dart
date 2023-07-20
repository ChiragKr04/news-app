import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/helpers/helpers.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/pages/DiscoverPage/controller/discover_controller.dart';
import 'package:news_api_app/pages/components/article_item.dart';
import 'package:news_api_app/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final DiscoverController viewController = DiscoverController();

  @override
  void initState() {
    super.initState();
    viewController.init();
  }

  Future<void> navigateToSearchView() async {
    await Navigator.pushNamed(
      context,
      CustomRoutes.searchViewPage,
      arguments: {
        "query": viewController.searchController.text.trim(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, _) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Discover',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: Text(
                  'News all around the world',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // a rounded textfield without borders
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  controller: viewController.searchController,
                  onSubmitted: (value) async {
                    await navigateToSearchView();
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.grey.shade300,
                    filled: true,
                    hintText: "Search",
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                    ),
                    suffixIcon: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () async {
                        await navigateToSearchView();
                      },
                      child: const Icon(
                        Icons.send_rounded,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 7.h,
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: viewController.allQueries.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                            onTap: () {
                              viewController.getNewsData(
                                viewController.allQueries[index],
                              );
                            },
                            child: Obx(
                              () => Chip(
                                backgroundColor:
                                    viewController.searchQuery.value ==
                                            viewController.allQueries[index]
                                        ? Colors.blue
                                        : null,
                                label: Text(
                                  viewController.allQueries[index].name.inCaps,
                                  style: TextStyle(
                                    color: viewController.searchQuery.value ==
                                            viewController.allQueries[index]
                                        ? Colors.white
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              // a horizontal listview
              if (viewController.isLoading.value)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (viewController.newsData.value == null &&
                  !viewController.isLoading.value)
                const Center(
                  child: Text("No News Found"),
                ),
              if (viewController.newsData.value != null &&
                  viewController.newsData.value!.articles.isEmpty)
                const Center(
                  child: Text("No News Found"),
                ),
              if (viewController.newsData.value != null &&
                  viewController.newsData.value!.articles.isNotEmpty)
                ...List.generate(
                  viewController.newsData.value!.articles.length,
                  (index) {
                    Article currentArticle =
                        viewController.newsData.value!.articles[index];
                    return ArticleItem(currentArticle: currentArticle);
                  },
                ),
            ],
          ),
        ),
      );
    });
  }
}
