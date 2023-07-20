import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/pages/UserBookmarks/controller/user_bookmark_controller.dart';
import 'package:news_api_app/pages/components/article_item.dart';

class UserBookMarks extends StatefulWidget {
  const UserBookMarks({super.key});

  @override
  State<UserBookMarks> createState() => _UserBookMarksState();
}

class _UserBookMarksState extends State<UserBookMarks> {
  final UserBookmarkController viewController = UserBookmarkController();

  @override
  void initState() {
    super.initState();
    viewController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (viewController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (viewController.userBookmarks.isEmpty) {
        return const Center(
          child: Text("No Bookmarks Found"),
        );
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Bookmarks',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: viewController.userBookmarks.length,
              itemBuilder: (context, index) {
                return ArticleItem(
                  currentArticle: viewController.userBookmarks[index],
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
