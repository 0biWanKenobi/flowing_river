import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final counterProvider = StateProvider((_) => 0);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  void _incrementCounter(BuildContext context) {
    context.read(counterProvider).state++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
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
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/favorites'),
                ),
                RaisedButton(
                  child: Text('Images'),
                  onPressed: () => Navigator.of(context).pushNamed('/images'),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
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
