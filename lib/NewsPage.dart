import 'package:flutter/material.dart';
import 'package:newsletter/Models/News.dart';
import 'package:http/http.dart' as http;

class NewsPage extends StatefulWidget {
  final String url;

  NewsPage(this.url);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Future<News> _getNews;

  Future<News> getNews() async {
    final response = await http.get(widget.url);
    return newsFromJson(response.body);
  }

  @override
  void initState() {
    _getNews = getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Newsletter'),
      ),
      body: Container(
        child: FutureBuilder<News>(
          future: _getNews,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final String title = snapshot.data.title;
                  final String description = snapshot.data.description;
                  final String image = snapshot.data.image;
                  final String user = snapshot.data.user;
                  final String date = snapshot.data.create;

                  return SingleChildScrollView(
                      child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Column(
                            children: <Widget>[
                              Image.network(image),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage("assets/avatar.jpg"),
                                  ),
                                  title: Text(title),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(user, style: TextStyle(fontWeight: FontWeight.bold),),
                                            Text(date),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(description),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            }
          }
        ),
      ),
    );
  }
}