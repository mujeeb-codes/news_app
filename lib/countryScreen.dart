import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/api_file.dart';
import 'package:news_app/category_screen.dart';
import 'package:news_app/country_screen_detail.dart';

class Countryscreen extends StatefulWidget {
  final String name, title;
  const Countryscreen({required this.name, required this.title, super.key});

  @override
  State<Countryscreen> createState() => _CountryscreenState();
}

class _CountryscreenState extends State<Countryscreen> {
  fetchApi api = fetchApi();
  late Future<dynamic> futurecall;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurecall = api.fetchnews(widget.name);
  }

  final format = DateFormat("dd MMM yy");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    final categories = ["sports", "entertainment", "business", "health"];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title + " Over all News",
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                              countryCode: widget.name,
                              category: cat,
                            ),
                          ),
                        );
                      },
                      child: Text(cat.toUpperCase()),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Expanded(
            child: FutureBuilder(
              future: futurecall,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SpinKitCircle(color: Colors.black, size: 50);
                } else if (snapshot.hasError) {
                  return Text("Error :${snapshot.error}");
                } else if (!snapshot.hasData) {
                  return Text("Error in data loading");
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
                              builder: (context) => CountryScreenDetail(
                                url: snapshot.data!.articles[index].url
                                    .toString(),
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
                                  Center(child: CircularProgressIndicator()),
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
                                  snapshot.data!.articles[index].source!.name ??
                                      "unKnown",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
