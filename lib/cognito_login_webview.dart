import 'package:data_spider/utils/constants.dart';
import 'package:data_spider/utils/routes.dart';
import 'package:data_spider/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CognitoLoginWebView extends StatefulWidget {
  final Function(String) onTokenReceived;

  const CognitoLoginWebView({super.key, required this.onTokenReceived});

  @override
  State<CognitoLoginWebView> createState() => _CognitoLoginWebViewState();
}

class _CognitoLoginWebViewState extends State<CognitoLoginWebView> {
  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(AppColors.white)
    ..loadRequest(Uri.parse(
        '$cognitoDomain/login?client_id=$cognitoClientId&response_type=token&scope=email+openid+phone&redirect_uri=http%3A%2F%2Flocalhost%2Fcallback'));
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
          print('WebView is loading (progress : $progress%)');
        },
        onPageStarted: (String url) {
          print('started $url');
          setState(() => _isLoading = true);
        },
        onPageFinished: (String url) {
          print('finished $url');
          setState(() => _isLoading = false);
        },
        onWebResourceError: (WebResourceError error) {
          print('error $error');
        },
        onNavigationRequest: (NavigationRequest request) {
          print('request ${request.url}');
          if (request.url.startsWith('http://localhost/callback')) {
            final token = _extractTokenFromUrl(request.url);
            if (token != null) {
              widget.onTokenReceived(token);
              Navigator.pop(context);
              // Routes.router.go('/');
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }

  String? _extractTokenFromUrl(String url) {
    Uri uri = Uri.parse(url);

    if (uri.fragment.isNotEmpty) {
      var fragments = uri.fragment.split('&');
      for (var fragment in fragments) {
        var keyValue = fragment.split('=');
        if (keyValue.length == 2 && keyValue[0] == 'id_token') {
          return keyValue[1];
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black45, // semi-transparent overlay
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
