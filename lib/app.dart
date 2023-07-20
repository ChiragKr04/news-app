import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_api_app/controllers/auth_controller.dart';
import 'package:news_api_app/routes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme).copyWith(
        labelSmall: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, _, __) {
      return SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          /// Setting up initial route
          initialRoute: CustomRoutes.initialRoute,

          /// Setting up routes
          routes: CustomRoutes.routes,

          /// Setting up theme
          theme: _buildTheme(Brightness.light),
        ),
      );
    });
  }
}
