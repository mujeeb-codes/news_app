import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/api_file.dart';
import 'package:news_app/category_detail.dart';

class CategoryScreen extends StatefulWidget {
  final String countryCode;
  final String category;

  const CategoryScreen({
    required this.countryCode,
    required this.category,
    super.key,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  fetchApi api = fetchApi();
  late Future<dynamic> futurecall;

  @override
  void initState() {
    super.initState();
    futurecall = api.fetchnews(widget.countryCode, category: widget.category);
  }

  final format = DateFormat("dd MMM yy");

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.category.toUpperCase()} News",
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: futurecall,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(color: Colors.black, size: 50),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Error in data loading"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.articles.length,
              itemBuilder: (context, index) {
                DateTime dateTime = DateTime.parse(
                  snapshot.data!.articles[index].publishedAt.toString(),
                );

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetail(
                          url: snapshot.data!.articles[index].url.toString(),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Container(
                      height: height * 0.32,
                      width: width * 0.3,
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'images/news_default.png',
                          fit: BoxFit.cover,
                        ),
                        fit: BoxFit.cover,
                        imageUrl: snapshot.data!.articles[index].image,
                      ),
                    ),
                    title: Text(
                      snapshot.data!.articles[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            snapshot.data!.articles[index].source?.name ??
                                "unKnown",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(format.format(dateTime)),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
