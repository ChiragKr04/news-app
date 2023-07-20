import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_api_app/helpers/helpers.dart';
import 'package:news_api_app/models/article.dart';
import 'package:news_api_app/pages/components/custom_glass_button.dart';
import 'package:news_api_app/repository/firebase_repository.dart';
import 'package:news_api_app/routes.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsInfoPage extends StatefulWidget {
  const NewsInfoPage({super.key});

  @override
  State<NewsInfoPage> createState() => _NewsInfoPageState();
}

class _NewsInfoPageState extends State<NewsInfoPage> {
  late Article currentArticle;
  bool isBookMarked = false;
  final FirebaseRepository firebaseRepository = FirebaseRepository();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentArticle = (ModalRoute.of(context)!.settings.arguments
        as Map<String, Article>)["article"] as Article;
    checkIfBookmarked();
  }

  Future<void> checkIfBookmarked() async {
    isBookMarked = await firebaseRepository.isBookMarked(currentArticle.title);
    log("isBookMarked: $isBookMarked");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
          ),
          Image.network(
            currentArticle.urlToImage ?? newsPlaceholder,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.5,
            errorBuilder: (context, error, stackTrace) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  newsPlaceholder,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            left: 20,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: generateRandomColor(),
                    child: Text(
                      currentArticle.source.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${currentArticle.source.name} • ${createTimeAgoString(currentArticle.publishedAt)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 30,
            child: CustomGlassButton(
              icon: Icons.arrow_back_ios_rounded,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: CustomGlassButton(
              icon: isBookMarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_outlined,
              color: isBookMarked ? Colors.blue : Colors.white,
              onTap: () async {
                FirebaseRepository().addArticleToBookMark(currentArticle);
                setState(() {
                  isBookMarked = !isBookMarked;
                });
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          currentArticle.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (currentArticle.description != null)
                          Text(
                            currentArticle.description ?? "",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        Text(
                          currentArticle.content ?? "",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (kIsWeb && Platform.isWindows) {
                                if (!await launchUrl(
                                    Uri.parse(currentArticle.url))) {
                                  throw Exception(
                                      'Could not launch ${currentArticle.url}');
                                }
                                return;
                              }
                              await Navigator.pushNamed(
                                context,
                                CustomRoutes.webNews,
                                arguments: {
                                  "url": currentArticle.url,
                                },
                              );
                            },
                            child: const Text(
                              "View Full Story",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
