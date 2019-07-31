import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MenuOptionButton extends StatelessWidget {
  final String id;

  MenuOptionButton(this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PopupMenuButton<Choice>(
        onSelected: (value){
          if(value.title == 'Delete'){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Warning!'),
                  content: Text('Are you sure to delete this news?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Delete'),
                      onPressed: () async {
                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        final String token = prefs.getString('token');
                        http.Response response;
                        response = await http.post(
                          'https://api.cambodiahr.com/api/v2/news/delete',
                          headers: {
                            HttpHeaders.authorizationHeader: "Bearer "+ token
                          },
                          body: {
                            'id': id
                          }
                        );
                        final Map<String, dynamic> resp = json.decode(response.body);
                        Navigator.pushReplacementNamed(context, '/my');
                      },
                    ),
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          }
        },
        itemBuilder: (BuildContext context) {
          return choices.map((Choice choice) {
            return PopupMenuItem<Choice>(
              value: choice,
              child: Text(choice.title),
            );
          }).toList();
        },
      ),
    );
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Delete')
];