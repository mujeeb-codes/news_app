import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Model_Worldwide.dart';
import 'package:news_app/api_file.dart';
import 'package:news_app/Model_Worldwide.dart';
import 'package:news_app/content_world_wide.dart';
import 'package:news_app/content_world_wide2.dart';
import 'package:news_app/countryScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiBbc apiBbc = ApiBbc();
  late Future<Model_Worldwide> Futurecall;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Futurecall = apiBbc.callapi();
  }

  final format = DateFormat("dd MMM yyyy, hh:mm a");
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Worldwide News",
          style: GoogleFonts.ubuntu(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Image(
            image: AssetImage("images/category_icon.png"),
            alignment: Alignment.bottomLeft,
          ),
          iconSize: 3,
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 38),
            onSelected: (value) {
              if (value == "pakistan") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Countryscreen(name: "pk", title: "Pakistan"),
                  ),
                );
              } else if (value == "india") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Countryscreen(name: "in", title: "India"),
                  ),
                );
              } else if (value == "australia") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Countryscreen(name: "au", title: "Australia"),
                  ),
                );
              } else if (value == "united kingdom") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Countryscreen(name: "gb", title: "UK"),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: "pakistan", child: Text("Pakistan")),
              PopupMenuItem(value: "india", child: Text("India")),
              PopupMenuItem(value: "australia", child: Text("Australia")),
              PopupMenuItem(
                value: "united kingdom",
                child: Text("United kingdom"),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder(
              future: Futurecall,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(color: Colors.black, size: 50),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error :${snapshot.error}");
                } else if (!snapshot.hasData) {
                  return Text("Data not loaded");
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                              builder: (context) => ContentWorldWide(
                                title: snapshot.data!.articles[index].title
                                    .toString(),
                                description: snapshot
                                    .data!
                                    .articles[index]
                                    .description
                                    .toString(),
                                content: snapshot.data!.articles[index].content
                                    .toString(),
                                url: snapshot.data!.articles[index].url
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Container(
                                height: height * .6,
                                width: width * .94,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                          "images/news_default.png",
                                          fit: BoxFit.cover,
                                        ),
                                    fit: BoxFit.cover,
                                    imageUrl: snapshot
                                        .data!
                                        .articles![index]
                                        .urlToImage
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Container(
                                  width: width * 0.87,
                                  height: height * .18,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.65),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            snapshot
                                                .data!
                                                .articles![index]
                                                .title
                                                .toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              format.format(dateTime),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot
                                                  .data!
                                                  .articles[index]
                                                  .source
                                                  .name
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Card(
            color: Colors.white70.withOpacity(.7),
            child: SizedBox(
              height: height * .5,
              width: width,
              child: FutureBuilder(
                future: Futurecall,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(color: Colors.black, size: 50),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error :${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return Text("Data not loaded");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.articles.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContentWorldWide2(
                                  title: snapshot.data!.articles[index].title
                                      .toString(),
                                  description: snapshot
                                      .data!
                                      .articles[index]
                                      .description
                                      .toString(),
                                  content: snapshot
                                      .data!
                                      .articles[index]
                                      .content
                                      .toString(),
                                  url: snapshot.data!.articles[index].url
                                      .toString(),
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Container(
                              height: height * 0.25,
                              width: width * 0.28,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(17),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.network(
                                        "https://via.placeholder.com/150",
                                        fit: BoxFit.cover,
                                      ),
                                  fit: BoxFit.cover,
                                  imageUrl: snapshot
                                      .data!
                                      .articles[index]
                                      .urlToImage
                                      .toString(),
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.articles[index].description
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            subtitle: Text(
                              snapshot.data!.articles[index].source.name
                                  .toString(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
