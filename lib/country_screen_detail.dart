import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CountryScreenDetail extends StatefulWidget {
  final String url;
  const CountryScreenDetail({required this.url, super.key});

  @override
  State<CountryScreenDetail> createState() => _CountryScreenDetailState();
}

class _CountryScreenDetailState extends State<CountryScreenDetail> {
  bool _isloading = true;
  bool _webViewError = false;
  late final WebViewController _controller;
  @override
  void initState() {
    // TODO: implement initState
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
          WebViewWidget(controller: _controller),
          if (_isloading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
