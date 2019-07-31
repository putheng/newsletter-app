
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newsletter/Models/News.dart';
import 'package:newsletter/NewsPage.dart';
import 'package:newsletter/Widget/AuthDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:newsletter/Widget/DeleteOption.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class MyNewsAuth extends StatefulWidget {


  @override
  _MyNewsAuthState createState() => _MyNewsAuthState();
}

class _MyNewsAuthState extends State<MyNewsAuth> with AutomaticKeepAliveClientMixin<MyNewsAuth>{
  @override
  bool get wantKeepAlive => true;

Future<List<News>> getNews() async {
  
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String token = prefs.getString('token');
  final response = await http.get(
    "https://api.cambodiahr.com/api/v2/news/my",
    headers: {
      HttpHeaders.authorizationHeader: "Bearer "+ token
    },
  );
  
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
        title: Text('My news'),
      ),
      drawer: AuthDrawer(),
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
                        final int id = snapshot.data[index].id;

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
                                        trailing: MenuOptionButton(id.toString())
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