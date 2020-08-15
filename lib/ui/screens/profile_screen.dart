import 'package:flutter/material.dart';
import 'package:flowing_river/ui/screens/home_screen.dart' show counterProvider;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final counter = useProvider(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        child: Center(
          child: Text(
            "${counter.state}",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      ),
    );
  }
}
