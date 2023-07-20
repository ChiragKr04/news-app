import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:news_api_app/controllers/auth_controller.dart';
import 'package:news_api_app/models/article.dart';

class FirebaseRepository {
  Future<void> addArticleToBookMark(Article article) async {
    // Implement the Firestore saving logic here.
    // This is just a basic example. You'll need to structure your Firestore data according to your needs.

    CollectionReference<Map<String, dynamic>> userBookmarksCollection =
        FirebaseFirestore.instance.collection('userBookmarks');
    String userId = Get.find<AuthController>().firebaseUser.value!.user!.uid;
    DocumentReference<Map<String, dynamic>> userBookmarkDoc =
        userBookmarksCollection.doc(userId);

    // Check if the article is already bookmarked
    bool isAlreadyBookmarked = await isBookMarked(article.title);

    // Fetch the existing data from Firestore
    userBookmarkDoc.get().then((documentSnapshot) {
      // Check if the document exists
      if (documentSnapshot.exists) {
        // Get the existing data from the document
        Map<String, dynamic> data = documentSnapshot.data()!;
        List<dynamic> existingArticles = data['articles'];

        if (isAlreadyBookmarked) {
          // If the article is already bookmarked, remove it from the list
          existingArticles.removeWhere((bookmark) =>
              bookmark['title'] != null &&
              bookmark['title'].toString().toLowerCase() ==
                  article.title.toLowerCase());
        } else {
          // If the article is not bookmarked, add it to the list
          existingArticles.add(article.toJson());
        }

        // Update the 'articles' field with the updated data
        userBookmarkDoc.set(
          {
            "articles": existingArticles,
          },
        ).then((_) {
          if (isAlreadyBookmarked) {
            log("Bookmark removed successfully");
          } else {
            log("Bookmark added successfully");
          }
        }).catchError((error) {
          log("Error updating bookmark: $error");
        });
      } else {
        // If the document doesn't exist, create a new one with the new article
        userBookmarkDoc
            .set(
              {
                "articles": [article.toJson()],
              },
            )
            .then((_) => log("Bookmark saved successfully"))
            .catchError((error) => log("Error saving bookmark: $error"));
      }
    }).catchError((error) {
      log("Error fetching bookmark data: $error");
    });
  }

  Future<bool> isBookMarked(String articleTitle) async {
    // Get a reference to the Firestore collection and document
    CollectionReference<Map<String, dynamic>> userBookmarksCollection =
        FirebaseFirestore.instance.collection('userBookmarks');
    String userId = Get.find<AuthController>().firebaseUser.value!.user!.uid;
    DocumentReference<Map<String, dynamic>> userBookmarkDoc =
        userBookmarksCollection.doc(userId);

    // Fetch the existing data from Firestore
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await userBookmarkDoc.get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      // Get the existing data from the document
      Map<String, dynamic> data = documentSnapshot.data()!;
      List<dynamic> existingArticles = data['articles'];

      // Check if any article in the list has the specified title
      bool articleExists = existingArticles.any((article) =>
          article['title'] != null &&
          article['title'].toString().toLowerCase() ==
              articleTitle.toLowerCase());

      return articleExists;
    }

    return false; // If the document doesn't exist or has no articles, return false
  }

  Future<List<Article>> fetchUserBooksMarks() async {
    String userId = Get.find<AuthController>().firebaseUser.value!.user!.uid;
    List<Article> bookmarkedArticles = [];

    try {
      // Get a reference to the Firestore collection and document
      CollectionReference<Map<String, dynamic>> userBookmarksCollection =
          FirebaseFirestore.instance.collection('userBookmarks');
      DocumentReference<Map<String, dynamic>> userBookmarkDoc =
          userBookmarksCollection.doc(userId);

      // Fetch the existing data from Firestore
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await userBookmarkDoc.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Get the existing data from the document
        Map<String, dynamic> data = documentSnapshot.data()!;
        List<dynamic> existingArticles = data['articles'];

        // Convert each article in the list to an Article object
        bookmarkedArticles = existingArticles.map((articleData) {
          // Assuming you have a constructor in your Article class that takes a map
          return Article.fromJson(articleData);
        }).toList();
      }
    } catch (error) {
      log("Error fetching bookmarked articles: $error");
    }

    return bookmarkedArticles;
  }
}
