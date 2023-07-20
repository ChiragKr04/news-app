import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_api_app/helpers/helpers.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/routes.dart';

class CustomCarousel extends StatefulWidget {
  const CustomCarousel({
    Key? key,
    required this.articles,
  }) : super(key: key);

  final List<Article> articles;

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late PageController _pageController;
  int activePage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);
  }

  Widget slider(
    List<Article> articles,
    int pagePosition,
    bool active,
  ) {
    double margin = active ? 5 : 10;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          CustomRoutes.newsInfoPage,
          arguments: {
            "article": articles[pagePosition],
          },
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.all(margin),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
                  BlendMode.darken,
                ),
                image: NetworkImage(
                  articles[pagePosition].urlToImage ?? newsPlaceholder,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: generateRandomColor(),
                      child: Text(
                        articles[pagePosition].source.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        "${articles[pagePosition].source.name} • ${createTimeAgoString(articles[pagePosition].publishedAt)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                // add healine
                Text(
                  articles[pagePosition].title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> indicators(
    int articleLength,
    int currentIndex,
  ) {
    return List<Widget>.generate(articleLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: PageView.builder(
                itemCount: widget.articles.length,
                pageSnapping: true,
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemBuilder: (context, pagePosition) {
                  bool active = pagePosition == activePage;
                  return slider(widget.articles, pagePosition, active);
                }),
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indicators(widget.articles.length, activePage))
      ],
    );
  }
}
