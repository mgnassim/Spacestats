import 'dart:convert';

import 'package:tuple/tuple.dart';

// Format:
// {
//   "titles": {
//     "canonical": "string",
//     "normalized": "string",
//     "display": "string"
//   },
//   "pageid": 0,
//   "extract": "string",
//   "extract_html": "string",
//   "thumbnail": {
//     "source": "string",
//     "width": 0,
//     "height": 0
//   },
//   "originalimage": {
//     "source": "string",
//     "width": 0,
//     "height": 0
//   },
//   "lang": "en",
//   "dir": "ltr",
//   "timestamp": {},
//   "description": "American poet",
//   "coordinates": {
//     "lat": 0,
//     "lon": 0
//   }
// }

/// A class to contain the response from the Wikipedia query.
///
/// [pageId] is the unique personal identifier associated to that wiki page.
class WikiMediaResponse {
  bool success;
  int? pageId;
  String? title;
  String? description;
  String? extract;
  List<Tuple2<String, String>>? langlinks;

  final Map<String, dynamic> rawResponse;

  WikiMediaResponse({
    required this.success,
    required this.rawResponse,
    this.pageId,
    this.title,
    this.description,
    this.extract,
    this.langlinks,
  });

  Map<String, dynamic> toMap() {
    return {
      'pageId': pageId,
      'title': title,
      'description': description,
      'extract': extract,
      'langlinks': langlinks
          ?.map(
            (x) => {
          'langcode': x.item1,
          'searchtitle': x.item2,
        },
      )
          .toList(),
      'rawResponse': rawResponse,
      'success': success,
    };
  }

  factory WikiMediaResponse.fromMap(Map<String, dynamic> map) {
    Map? path = map['query']?['pages'];
    String? key = path?.keys.first;

    return WikiMediaResponse(
      pageId: path?[key]?['pageid'],
      title: path?[key]?['title'],
      description: path?[key]?['description'],
      extract: path?[key]?['extract'],
      langlinks: path?[key]?['langlinks']
          ?.map<Tuple2<String, String>>(
            (e) => Tuple2(e['lang'] as String, e['*'] as String),
      )
          ?.toList(),
      rawResponse: map,
      success: path?[key]?['title'] != null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WikiMediaResponse.fromJson(String source) =>
      WikiMediaResponse.fromMap(json.decode(source));

  @override
  String toString() => 'WikiResponse(${toMap().toString()})';
}
