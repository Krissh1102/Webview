import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview/views/provider/webview_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class WebViewScreen extends ConsumerStatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends ConsumerState<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    WebViewPlatform.instance ??= AndroidWebViewPlatform();

   
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(ref.read(urlProvider)))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            ref.read(loadingStateProvider.notifier).state = true;
          },
          onPageFinished: (_) {
            ref.read(loadingStateProvider.notifier).state = false;
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            ref.read(loadingStateProvider.notifier).state = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Failed to load page: ${error.description}")),
            );
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loadingStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gaming Platform'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
