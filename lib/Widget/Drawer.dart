import 'package:flutter/material.dart';

class GuestDrawer extends StatelessWidget {
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
                  Navigator.pushReplacementNamed(context, '/');
                }
              ),
              Divider(),
              ListTile(
                title: Text('Register'),
                leading: Icon(Icons.supervised_user_circle),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.0,),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/register');
                }
              ),
              Divider(),
              ListTile(
                title: Text('Login'),
                leading: Icon(Icons.lock_open),
                trailing: Icon(Icons.arrow_forward_ios, size: 15.0,),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/login');
                }
              ),
              Divider(),
            ],
          ),
        ),
      );
  }
}