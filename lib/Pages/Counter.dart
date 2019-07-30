import 'package:flutter/material.dart';
import 'package:newsletter/Widget/Decrement.dart';
import 'package:newsletter/Widget/Increment.dart';
import 'package:provider/provider.dart';
import 'package:newsletter/Blocs/CounterBloc.dart';

class CounterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = Provider.of<CounterBloc>(context);
    
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                counterBloc.counter.toString(),
                style: TextStyle(fontSize: 62.0),
              ),
              IncrementButton(),
              DecrementButton(),
            ],
          ),
        )
      )
    );
  }
}