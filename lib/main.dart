import 'package:flutter/material.dart';
import 'package:newsletter/Blocs/LoginBloc.dart';
import 'package:newsletter/Home.dart';
import 'package:newsletter/Login.dart';
import 'package:newsletter/Pages/Create.dart';
import 'package:newsletter/Pages/HomeAuth.dart';
import 'package:newsletter/Pages/MyNews.dart';
import 'package:newsletter/Register.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginBloc>.value(
          value: LoginBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: CounterPage(),
        routes: {
          '/': (BuildContext context) => MyHomePage(),
          '/home': (BuildContext context) => MyHomeAuth(),
          '/create': (BuildContext context) => CreateNews(),
          '/my': (BuildContext context) => MyNewsAuth(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => MyHomePage()
          );
        }
      ),
    );
  }
}

