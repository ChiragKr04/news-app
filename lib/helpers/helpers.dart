import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math';

Color generateRandomColor() {
  Random random = Random();

  // Generate random RGB color channels
  int red = random.nextInt(256); // 0 to 255
  int green = random.nextInt(256); // 0 to 255
  int blue = random.nextInt(256); // 0 to 255

  // Calculate the brightness of the color (0 to 255)
  int brightness = ((red * 299) + (green * 587) + (blue * 114)) ~/ 1000;

  // Ensure the generated color is not too bright (brightness > 200) and not too dark (brightness < 55)
  while (brightness > 200 || brightness < 55) {
    red = random.nextInt(256);
    green = random.nextInt(256);
    blue = random.nextInt(256);
    brightness = ((red * 299) + (green * 587) + (blue * 114)) ~/ 1000;
  }

  return Color.fromARGB(255, red, green, blue);
}

/// Adding a helper function to check if ScrollController has reached bottom
/// If its reached then perform any function
extension BottomReachExtension on ScrollController {
  void onBottomReach(
    VoidCallback callback, {
    double sensitivity = 300.0,
  }) {
    addListener(() {
      final bool isReverse =
          position.userScrollDirection == ScrollDirection.reverse;

      final bool reachedSensitivePixels = position.extentAfter < sensitivity;
      if (isReverse && reachedSensitivePixels) {
        callback();
      }
    });
  }
}

String createTimeAgoString(DateTime time) {
  final DateTime now = DateTime.now();
  final DateTime lastActiveTime = time;
  final Duration difference = now.difference(lastActiveTime);
  if (difference.inDays > 0) {
    return '${difference.inDays} days';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hours';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minutes';
  } else {
    return 'Now';
  }
}

extension StringInCaps on String {
  String get inCaps => '${this[0].toUpperCase()}${substring(1)}';
}

const String newsPlaceholder =
    "https://khabaronline24.in/public/user/images/3d-world-news.jpg";
