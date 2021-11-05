import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:monline/models/newsgetmod.dart';
import 'package:url_launcher/url_launcher.dart';

class Berita extends StatefulWidget {
  @override
  _BeritaState createState() => _BeritaState();
}

class _BeritaState extends State<Berita> {
  bool isLoading = true;
  Newsgetmod news;
  http.Response response;

  void getNews() async {
    DateTime date = DateTime.now();
    isLoading = true;
    setState(() {});
    response = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?q=otomotif&from=${date.year}-${date.month}-${date.day - 1}&sortBy=publishedAt&domain=Viva.co.id&apiKey=7c8823612e3644fdb35ca058cd4da00f"));
    if (response.statusCode == 200) {
      news = newsgetmodFromJson(response.body);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: news.articles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () async {
                      launch(news.articles[index].url);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child:
                                Image.network(news.articles[index].urlToImage),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text(news.articles[index].title),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              news.articles[index].description,
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
