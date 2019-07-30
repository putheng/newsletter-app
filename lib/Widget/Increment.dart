import 'package:flutter/material.dart';
import 'package:newsletter/Blocs/CounterBloc.dart';
import 'package:provider/provider.dart';

class IncrementButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final CounterBloc counterBloc = Provider.of<CounterBloc>(context);
    return FlatButton.icon(
      icon: Icon(Icons.add),
      label: Text("Add"),
      onPressed: () => counterBloc.increment(),
    );
  }
}