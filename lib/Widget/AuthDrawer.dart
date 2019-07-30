import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: GestureDetector(
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/avatar.jpg"),
                  ),
                ),
                accountName: Text("Newsletter", style: TextStyle(fontSize: 22.0),),
                accountEmail: Text(".", style: TextStyle(color:Colors.transparent),),
                decoration: BoxDecoration(
                  color: Colors.lightBlue
                ),
                otherAccountsPictures: <Widget>[
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/kh.png"),
                    ),
                    onTap: () {
                    },
                  ),
                  GestureDetector(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/en.png"),
                    ),
                    onTap: () {
                    },
                  ),
                ],
              ),
              ListTile(
                title: Text('Home'),
                leading: Icon(Icons.home),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.0,),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/home');
                }
              ),
              Divider(),
              ListTile(
                title: Text('Create News'),
                leading: Icon(Icons.add),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.0,),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/create');
                }
              ),
              Divider(),
              ListTile(
                title: Text('Logut'),
                leading: Icon(Icons.lock_outline),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.0,),
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('token');
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/');
                }
              ),
            ],
          ),
        ),
      );
  }
}