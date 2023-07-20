import 'package:get/get.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/repository/firebase_repository.dart';

class UserBookmarkController {
  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  RxBool isLoading = false.obs;
  RxList<Article> userBookmarks = RxList<Article>();

  void init() {
    fetchUserBooksMarks();
  }

  Future<void> fetchUserBooksMarks() async {
    isLoading.value = true;
    var data = await _firebaseRepository.fetchUserBooksMarks();
    userBookmarks.value = data;
    isLoading.value = false;
  }
}
