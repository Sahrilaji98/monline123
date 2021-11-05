// To parse this JSON data, do
//
//     final newsgetmod = newsgetmodFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Newsgetmod newsgetmodFromJson(String str) =>
    Newsgetmod.fromJson(json.decode(str));

String newsgetmodToJson(Newsgetmod data) => json.encode(data.toJson());

class Newsgetmod {
  Newsgetmod({
    @required this.status,
    @required this.totalResults,
    @required this.articles,
  });

  String status;
  int totalResults;
  List<Article> articles;

  factory Newsgetmod.fromJson(Map<String, dynamic> json) => Newsgetmod(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    @required this.source,
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.urlToImage,
    @required this.publishedAt,
    @required this.content,
  });

  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  DateTime publishedAt;
  String content;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

class Source {
  Source({
    @required this.id,
    @required this.name,
  });

  dynamic id;
  Name name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: nameValues.map[json["name"]],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nameValues.reverse[name],
      };
}

enum Name { VIVA_CO_ID }

final nameValues = EnumValues({"Viva.co.id": Name.VIVA_CO_ID});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
