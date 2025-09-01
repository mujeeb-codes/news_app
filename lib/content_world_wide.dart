import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/full_article_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContentWorldWide extends StatefulWidget {
  final String title, description, content, url;
  const ContentWorldWide({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    super.key,
  });

  @override
  State<ContentWorldWide> createState() => _ContentWorldWideState();
}

class _ContentWorldWideState extends State<ContentWorldWide> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final Width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "More Info",
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Card(
        color: Colors.white70,
        child: ListView(
          children: [
            SizedBox(height: 38),
            Container(
              width: Width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: BoxBorder.all(color: Colors.black, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Title : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.title),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            Container(
              width: Width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: BoxBorder.all(color: Colors.black, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Description : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: widget.description),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 60),
            Container(
              width: Width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.black, width: 2),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Content : ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: widget.content),
                      ],
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullArticleScreen(url: widget.url),
                        ),
                      );
                    },
                    child: Text(
                      "Read More",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
