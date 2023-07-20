import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebNews extends StatefulWidget {
  const WebNews({super.key});

  @override
  State<WebNews> createState() => _WebNewsState();
}

class _WebNewsState extends State<WebNews> {
  late WebViewController webController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Getting url from arguments passed from previous screen
    final String url = (ModalRoute.of(context)!.settings.arguments
            as Map<String, String>)["url"]
        .toString();

    /// Initializing web controller with url
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: WebViewWidget(controller: webController),
    );
  }
}
