import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetail extends StatefulWidget {
  final String url;
  const CategoryDetail({required this.url, super.key});

  @override
  State<CategoryDetail> createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  late final WebViewController _controller;
  bool _isloading = true;
  bool _webViewError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isloading = true;
              _webViewError = false;
            });
          },
          onPageFinished: (url) {
            setState(() => _isloading = false);
          },
          onWebResourceError: (error) async {
            setState(() {
              _webViewError = true;
              _isloading = false;
            });
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.inAppWebView);
              if (mounted) Navigator.pop(context);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Full Article",
          style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () async {
              final uri = Uri.parse(widget.url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.inAppWebView);
              } 
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_webViewError) WebViewWidget(controller: _controller),
          if (_isloading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
