import 'package:flutter/cupertino.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/* // TODO: delte this class
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key, required this.url});
  final String url;
  @override
  Widget build(BuildContext context) {
    // TODO: clean
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        // TODO: text
        title: Text('webview'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
 */
