import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newsletter/Blocs/LoginBloc.dart';
import 'package:newsletter/Widget/AuthDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateNews extends StatefulWidget {
  @override
  _CreateNewsState createState() => _CreateNewsState();
}

class _CreateNewsState extends State<CreateNews> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'image': null,
  };
  
  File _imageFile;
  String emptyImage = null;

void _openImagePicker(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context){
        return Container(
          height: 150.0,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text('Pick an Image'),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.orangeAccent[100],
                textColor: Color(0xFF525252),
                child: Text('User Camera'),
                onPressed: (){
                  _getImage(context, ImageSource.camera);
                },
              ),
              FlatButton(
                color: Colors.orangeAccent[100],
                textColor: Color(0xFF525252),
                child: Text('User Gallery'),
                onPressed: (){
                  _getImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(
      source: source,
      maxWidth: 1000.0
    ).then((File image){
      setState(() {
       _imageFile = image;
       _formData['image'] = image;
      });
      Navigator.pop(context);
    });
  }

Widget _buildTitleTextField() {
    return TextFormField(
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.orangeAccent[100], width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.orangeAccent[100], width: 1.0),
          ),
          labelText: 'Title',
          filled: true,
          fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title invalid';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.orangeAccent[100], width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.orangeAccent[100], width: 1.0),
          ),
          labelText: 'Description',
          filled: true,
          fillColor: Colors.white),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Description invalid';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
      },
    );
  }

  void _submitForm(loginBloc) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if(_formData['image'] == null){
      setState(() {
        emptyImage = 'Please select an image!'; 
      });
      return;
    }
    loginBloc.starLoading();

    _formKey.currentState.save();

    http.Response response;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String title = _formData['title'];
    final String description = _formData['description'];
    final File image = _formData['image'];
    final String token = prefs.getString('token');

    String fileName = image.path.split("/").last;

    String base64Image = base64Encode(image.readAsBytesSync());

    response = await http.post(
      "https://api.cambodiahr.com/api/v2/news/create",
      headers: {
        HttpHeaders.authorizationHeader: "Bearer "+ token
      },
      body: {
        'title' : title,
        'description' : description,
        'image' : fileName,
        'base64': base64Image
      }
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    
    loginBloc.stopLoading();
    
    if(responseData['status']){
      Navigator.pushReplacementNamed(context, '/my');
    }
  }
  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Create news'),
      ),
      drawer: AuthDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
          child: Container(
            width: targetWidth,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  emptyImage != null ? Padding(
                    padding: const EdgeInsets.only(bottom:15.0),
                    child: Text(emptyImage, style: TextStyle(color: Colors.red),),
                  ) : Text(''),
                  FlatButton(
                      onPressed: () {
                        _openImagePicker(context);
                      },
                      child: _imageFile == null 
                        ? Image.asset('assets/empty.png', width: 100.0, height: 100.0)
                        : Image.file(_imageFile, fit:BoxFit.cover, width: 300.0, height: 300.0,)
                  ),
                  SizedBox(height: 20.0),
                  _buildTitleTextField(),
                  SizedBox(height: 10.0),
                  _buildDescriptionTextField(),
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
                            Text('CREATE',
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
                ]
            )
            )
          )
        ),
      ),
    );
  }
}