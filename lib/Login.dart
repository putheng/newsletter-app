
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsletter/Blocs/LoginBloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsletter/Widget/Drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loading = false;

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
        ),
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white
        ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'This field is required!';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
          ),
          labelText: 'Password', filled: true, fillColor: Colors.white
        ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

    void _submitForm(loginBloc) async {
    
      if (!_formKey.currentState.validate()) {
        return;
      }
      
      loginBloc.starLoading();

      _formKey.currentState.save();
      http.Response response;
      final String password = _formData['password'];
      final String email = _formData['email'];

      response = await http.post('https://api.cambodiahr.com/api/login',
        body: {
          'password': password,
          'email': email
        }
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if(responseData['error'] == 'Unauthorized'){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Authentication failed"),
              content: Text("We could not find an account associated with that information"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        loginBloc.stopLoading();
        return;
      }

      loginBloc.stopLoading();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['access_token']);

      Navigator.pushReplacementNamed(context, '/home');
    }

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Newsletter'),
      ),
      drawer: GuestDrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10.0),
            width: targetWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100.0)),
                      image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(child: _buildEmailTextField(), height: 45.0,),
                  SizedBox(height: 10.0),
                  Container(height: 45.0,child: _buildPasswordTextField()),
                  SizedBox(height: 20.0),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: FlatButton(
                      disabledColor: Colors.black12,
                      onPressed: (){
                        _submitForm(loginBloc);
                      },
                      color: Colors.lightBlue,
                      textColor: Color(0xFF525252),
                      child: Padding(
                        padding: const EdgeInsets.only(top:13.0, bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            loginBloc.loading ? Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: CupertinoActivityIndicator(),
                            ) : Text(''),
                            Text('LOGIN',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  letterSpacing: 2.0
                                )
                            ),
                          ],
                        ),
                      )
                    )
                  ),
                  SizedBox(height: 30.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}