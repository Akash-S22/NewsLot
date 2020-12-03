import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:connectivity/connectivity.dart';
import './get_news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory location = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(location.path);
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(ArticlesAdapter());
  Hive.registerAdapter(SourceAdapter());
  await Hive.openBox('newsapi');
  runApp(NewsApp());
}

class NewsApp extends StatefulWidget {
  @override
  NewsAppState createState() => NewsAppState();
}

class NewsAppState extends State<NewsApp> {
  var news;
  var newsapibox = Hive.box('newsapi');
  Data response;
  bool network;

  checkconnection() async {
    var initnetwork = await Connectivity().checkConnectivity();
    if (initnetwork == ConnectivityResult.none) {
      setState(() {
        network = false;
      });
    }
    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult networkdata) {
      if (networkdata == ConnectivityResult.none) {
        print("not connected");
        setState(() {
          network = false;
        });
      } else {
        print("connected");
        setState(() {
          network = true;
          getNews();
        });
      }
    });
  }

  getNews() async {
    try {
      FetchNews news = FetchNews(new Dio());
      this.response = await news.getNews();
    } catch (e) {
      if (e.runtimeType == DioError) {
        print('No Internet Connection');
      } else {
        print('Something Went Wrong');
      }
    } finally {
      if (response != null) {
        setState(() {
          newsapibox.put(0, response);
          this.news = newsapibox.getAt(0).articles;
        });
      } else {
        setState(() {
          this.news = newsapibox.getAt(0).articles;
          // var filtered = newsapibox.values.where((response) => response.status.startsWith('o'));
          // print(filtered);
        });
      }
    }
  }

  @override
  void initState() {
    getNews();
    checkconnection();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NewsLot',
      home: Scaffold(
        appBar: AppBar(
          title: Text('News API',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 5)),
        ),
        body: news == null ? loading() : display(),
        bottomNavigationBar: network == false
            ? Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.red),
                child: news == null
                    ? Text("Please Connect to Internet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5))
                    : Text("Offline",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5)),
              )
            : SizedBox(
                width: 0,
                height: 0,
              ),
      ),
    );
  }

  Widget display() {
    return (ListView.builder(
        itemCount: news.length == null ? 0 : news.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                        news[index].urlToImage == null
                            ? 'https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-1-scaled-1150x647.png'
                            : news[index].urlToImage,
                        loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : LinearProgressIndicator();
                    })),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      news[index].title == null ? '' : news[index].title,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                      news[index].description == null
                          ? ''
                          : news[index].description,
                      style: TextStyle(fontSize: 12)),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                      news[index].content == null ? '' : news[index].content,
                      style: TextStyle(fontSize: 10)),
                ),
                Padding(
                    padding: EdgeInsets.all(5),
                    child: InkWell(
                        child: Text('Click here to read more',
                            style: TextStyle(fontSize: 10, color: Colors.blue)),
                        onTap: () {
                          launch(
                              news[index].url == null ? '' : news[index].url);
                        })),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                          news[index].author == null ? '' : news[index].author,
                          style: TextStyle(fontSize: 10)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text(
                          news[index].source.name == null
                              ? ''
                              : news[index].source.name,
                          style: TextStyle(fontSize: 10)),
                    ),
                  ],
                )
              ],
            ),
          );
        }));
  }

  Widget loading() {
    return (Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.all(25),
            child: Text('Latest News Are On The Way! Please Wait...',
                style: TextStyle(
                    fontSize: 10, color: Theme.of(context).primaryColor)),
          )
        ],
      ),
    ));
  }
}
