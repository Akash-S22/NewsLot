import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:hive/hive.dart';

part 'get_news.g.dart';

@RestApi(baseUrl: "https://newsapi.org/v2")
abstract class FetchNews {
  factory FetchNews(Dio dio) = _FetchNews;
  @GET("/top-headlines?country=in&apiKey= <Your ApiKey> ")
  Future<Data> getNews();
}

@JsonSerializable()
@HiveType(typeId: 0)
class Data {
  @HiveField(0)
  List<Articles> articles;
  @HiveField(1)
  String status;
  @HiveField(2)
  int totalResults;
  Data({
    this.articles,
    this.status,
    this.totalResults,
  });

  Data copyWith({
    List<Articles> articles,
    String status,
    int totalResults,
  }) {
    return Data(
      articles: articles ?? this.articles,
      status: status ?? this.status,
      totalResults: totalResults ?? this.totalResults,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'articles': articles?.map((x) => x?.toMap())?.toList(),
      'status': status,
      'totalResults': totalResults,
    };
  }

  factory Data.fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return Data(
      articles:
          List<Articles>.from(map['articles']?.map((x) => Articles.fromMap(x))),
      status: map['status'],
      totalResults: map['totalResults'],
    );
  }

  String toJson() => json.encode(toMap());

  //factory Data.fromJson(String source) => Data.fromMap(json.decode(source));

  @override
  String toString() =>
      'Data(articles: $articles, status: $status, totalResults: $totalResults)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Data &&
        listEquals(o.articles, articles) &&
        o.status == status &&
        o.totalResults == totalResults;
  }

  @override
  int get hashCode =>
      articles.hashCode ^ status.hashCode ^ totalResults.hashCode;
}

@JsonSerializable()
@HiveType(typeId: 1)
class Articles {
  @HiveField(3)
  Source source;
  @HiveField(4)
  String author;
  @HiveField(5)
  String content;
  @HiveField(6)
  String description;
  @HiveField(7)
  String publishedAt;
  @HiveField(8)
  String title;
  @HiveField(9)
  String url;
  @HiveField(10)
  String urlToImage;
  Articles({
    this.source,
    this.author,
    this.content,
    this.description,
    this.publishedAt,
    this.title,
    this.url,
    this.urlToImage,
  });

  Articles copyWith({
    Source source,
    String author,
    String content,
    String description,
    String publishedAt,
    String title,
    String url,
    String urlToImage,
  }) {
    return Articles(
      source: source ?? this.source,
      author: author ?? this.author,
      content: content ?? this.content,
      description: description ?? this.description,
      publishedAt: publishedAt ?? this.publishedAt,
      title: title ?? this.title,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'source': source?.toMap(),
      'author': author,
      'content': content,
      'description': description,
      'publishedAt': publishedAt,
      'title': title,
      'url': url,
      'urlToImage': urlToImage,
    };
  }

  factory Articles.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Articles(
      source: Source.fromMap(map['source']),
      author: map['author'],
      content: map['content'],
      description: map['description'],
      publishedAt: map['publishedAt'],
      title: map['title'],
      url: map['url'],
      urlToImage: map['urlToImage'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory Articles.fromJson(String source) =>
  //     Articles.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Articles(source: $source, author: $author, content: $content, description: $description, publishedAt: $publishedAt, title: $title, url: $url, urlToImage: $urlToImage)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Articles &&
        o.source == source &&
        o.author == author &&
        o.content == content &&
        o.description == description &&
        o.publishedAt == publishedAt &&
        o.title == title &&
        o.url == url &&
        o.urlToImage == urlToImage;
  }

  @override
  int get hashCode {
    return source.hashCode ^
        author.hashCode ^
        content.hashCode ^
        description.hashCode ^
        publishedAt.hashCode ^
        title.hashCode ^
        url.hashCode ^
        urlToImage.hashCode;
  }
}

@JsonSerializable()
@HiveType(typeId: 2)
class Source {
  @HiveField(11)
  String id;
  @HiveField(12)
  String name;
  Source({
    this.id,
    this.name,
  });

  Source copyWith({
    String id,
    String name,
  }) {
    return Source(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Source.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Source(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory Source.fromJson(String source) => Source.fromMap(json.decode(source));

  @override
  String toString() => 'Source(id: $id, name: $name)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Source && o.id == id && o.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
