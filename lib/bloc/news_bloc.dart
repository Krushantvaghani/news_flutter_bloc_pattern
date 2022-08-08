import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:bloc_pattern_demo/model/newsinfo_model.dart';
import 'package:http/http.dart' as http;

enum NewsAction {
  Fetch,
  Delete,
}

class NewsBloc {
  final stateStreamController = StreamController<List<Article>>();
  StreamSink<List<Article>> get newsSink => stateStreamController.sink;
  Stream<List<Article>> get newsStream => stateStreamController.stream;

  // Only for eventStream perform event
  final eventStreamController = StreamController<NewsAction>();
  StreamSink<NewsAction> get eventSink => eventStreamController.sink;
  Stream<NewsAction> get eventStream => eventStreamController.stream;

  NewsBloc() {
    eventStream.listen((event) async {
      if (event == NewsAction.Fetch) {
        try {
          var news = await getNews();
          if (news != null) {
            newsSink.add(news.articles!);
          } else {
            newsSink.addError("Something went wrong");
          }
        } on Exception catch (e) {
          // TODO
          newsSink.addError("Something went wrong");
        }
      }
    });
  }

  Future<NewsModel> getNews() async {
    var client = http.Client();
    var newsModel;

    try {
      var response = await client.get(Uri.parse(
          'http://newsapi.org/v2/everything?domains=wsj.com&apiKey=cae38cf3316a4f59a14d909090a7cf94'));
      if (response.statusCode == 200) {
        var jsonString = response.body;
        var jsonMap = json.decode(jsonString);

        newsModel = NewsModel.fromJson(jsonMap);
      }
    } on Exception {
      return newsModel;
    }
    return newsModel;
  }

  void dispose() {
    stateStreamController.close();
    eventStreamController.close();
  }
}
