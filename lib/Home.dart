
import 'package:flutter/material.dart';
import 'package:newsletter/Models/News.dart';
import 'package:newsletter/NewsPage.dart';
import 'package:newsletter/Widget/Drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin<MyHomePage>{
  @override
  bool get wantKeepAlive => true;

Future<List<News>> getNews() async {
  final response = await http.get('https://api.cambodiahr.com/api/news');
  
  return getNewsJson(response.body);
}

  Future<List<News>> _getNews;

    @override
  void initState() {
    _getNews = getNews();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Latest news'),
      ),
      drawer: GuestDrawer(),
      body: Container(
          decoration: BoxDecoration(color: Colors.black12),
          child: FutureBuilder<List<News>>(
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
                    return snapshot.data.length == 0 ? Center(child: Text('Empty')) : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String title = snapshot.data[index].title;
                        final String description = snapshot.data[index].description;
                        final String image = snapshot.data[index].image;
                        final String url = snapshot.data[index].url;

                        return GestureDetector(
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                  NewsPage(url)
                                )
                              );
                            },
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
                                        title: Text(title),
                                        subtitle: Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: Text(
                                            description.length <= 190
                                                ? description
                                                : description.substring(0, 200) + ' ...',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    );
                  }
              }
            }),
        ),
    );
  }
}