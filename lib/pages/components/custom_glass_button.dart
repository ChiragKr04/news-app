import 'dart:ui';

import 'package:flutter/material.dart';

class CustomGlassButton extends StatelessWidget {
  const CustomGlassButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final Function onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF6F6F7).withOpacity(0.5),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
