import 'package:flutter/material.dart';

class LoginBloc extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  set loading(bool val){
    _loading = val;

    notifyListeners();
  }

  stopLoading(){
    _loading = false;
    notifyListeners();
  }

  starLoading(){
    _loading = true;
    notifyListeners();
  }
}