import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/helpers/helpers.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/pages/SearchViewPage/controller/search_view_controller.dart';
import 'package:news_api_app/pages/components/article_item.dart';
import 'package:news_api_app/pages/components/custom_glass_button.dart';

class SearchViewPage extends StatefulWidget {
  const SearchViewPage({super.key});

  @override
  State<SearchViewPage> createState() => _SearchViewPageState();
}

class _SearchViewPageState extends State<SearchViewPage> {
  late String query;

  SearchViewController viewController = SearchViewController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    query = (ModalRoute.of(context)!.settings.arguments
        as Map<String, String>)["query"] as String;
    viewController.init(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CustomGlassButton(
                    icon: Icons.arrow_back_ios_rounded,
                    color: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    query.inCaps,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
            ),
            if (viewController.articles.isEmpty && !viewController.isSearching)
              const Center(
                child: Text("No News Found"),
              ),
            if (viewController.articles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  controller: viewController.scrollController,
                  itemCount: viewController.articles.length,
                  itemBuilder: (context, index) {
                    Article currentArticle = viewController.articles[index];
                    return ArticleItem(currentArticle: currentArticle);
                  },
                ),
              ),
            if (viewController.isSearching)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            if (viewController.hasReachedEnd)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("That's all folks!"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
