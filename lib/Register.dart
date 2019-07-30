
import 'package:flutter/material.dart';
import 'package:newsletter/Widget/Drawer.dart';

class RegisterPage extends StatefulWidget {


  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'username': null,
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

        if(double.tryParse(value) == null && !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)){
          return 'Invalid email or phone number';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

Widget _buildUsernameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
        ),
        labelText: 'Username',
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

  @override
  Widget build(BuildContext context) {
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(child: _buildUsernameTextField(), height: 45.0,),
                  SizedBox(height: 10.0),
                  Container(child: _buildEmailTextField(), height: 45.0,),
                  SizedBox(height: 10.0),
                  Container(
                    height: 45.0,
                    child: _buildPasswordTextField()),
                  SizedBox(height: 20.0),
                  FractionallySizedBox(
                    widthFactor: 0.6,
                    child: FlatButton(
                      onPressed: (){
                        
                      },
                      color: Colors.lightBlue,
                      textColor: Color(0xFF525252),
                      child: Padding(
                        padding: const EdgeInsets.only(top:13.0, bottom: 12.0),
                        child: Text('REGISTER',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 2.0
                            )
                        ),
                      )
                    )
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}