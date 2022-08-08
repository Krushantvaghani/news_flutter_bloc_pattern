import 'package:bloc_pattern_demo/bloc/news_bloc.dart';
import 'package:bloc_pattern_demo/model/newsinfo_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // late Future<NewsModel> _newsModel;
  final _newsBloc = NewsBloc();
  dynamic newsBloc;

  @override
  void initState() {
    _newsBloc.eventSink.add(NewsAction.Fetch);
    super.initState();
  }

  @override
  void dispose() {
    newsBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: StreamBuilder<List<Article>>(
        stream: _newsBloc.newsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  dynamic article = snapshot.data![index];
                  var formattedTime =
                      DateFormat('dd MMM - HH:mm').format(article.publishedAt);
                  return Container(
                    height: 100,
                    margin: const EdgeInsets.all(8),
                    child: Row(
                      children: <Widget>[
                        Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Image.network(
                                article.urlToImage,
                                fit: BoxFit.cover,
                              )),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(formattedTime),
                              Text(
                                article.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                article.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
