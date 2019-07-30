import 'package:flutter/material.dart';
import 'package:newsletter/Blocs/CounterBloc.dart';
import 'package:newsletter/Blocs/LoginBloc.dart';
import 'package:newsletter/Home.dart';
import 'package:newsletter/Login.dart';
import 'package:newsletter/Pages/Counter.dart';
import 'package:newsletter/Pages/Create.dart';
import 'package:newsletter/Pages/HomeAuth.dart';
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
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
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

