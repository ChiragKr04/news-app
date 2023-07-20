import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_api_app/controllers/auth_controller.dart';
import 'package:news_api_app/pages/DiscoverPage/discover_page.dart';
import 'package:news_api_app/pages/HomePage/home_page.dart';
import 'package:news_api_app/pages/UserBookmarks/user_book_marks.dart';

enum AppTabViews { home, discover, bookmarks }

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  Rx<AppTabViews> currentView = AppTabViews.home.obs;
  RxInt currentIndex = 0.obs;
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _getNavBar(),
        body: Obx(() => _getBody()),
      ),
    );
  }

  Widget _getBody() {
    switch (currentView.value) {
      case AppTabViews.home:
        return const HomePage();
      case AppTabViews.discover:
        return const DiscoverPage();
      case AppTabViews.bookmarks:
        return const UserBookMarks();
    }
  }

  Widget _getNavBar() {
    return Obx(
      () => NavigationBar(
        elevation: 10,
        backgroundColor: Colors.white,
        selectedIndex: currentIndex.value,
        indicatorColor: Colors.blue,
        onDestinationSelected: (index) {
          currentIndex.value = index;
          switch (index) {
            case 0:
              currentView.value = AppTabViews.home;
              break;
            case 1:
              currentView.value = AppTabViews.discover;
              break;
            case 2:
              currentView.value = AppTabViews.bookmarks;
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.language_rounded),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_added),
            label: 'Bookmarks',
          ),
        ],
      ),
    );
  }
}
