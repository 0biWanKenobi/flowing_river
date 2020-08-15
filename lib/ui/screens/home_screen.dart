import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

final counterProvider = StateProvider((_) => 0);

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Counter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text('Profile'),
                onPressed: () => Navigator.of(context).pushNamed('/profile'),
              ),
              RaisedButton(
                child: Text('Favorites'),
                onPressed: () => Navigator.of(context).pushNamed('/favorites'),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Counter extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useProvider(counterProvider).state;
    return Text(
      '$counter',
      style: Theme.of(context).textTheme.headline4,
    );
  }
}
