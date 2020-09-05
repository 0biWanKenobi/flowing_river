import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginStatusProvider = StateProvider((_) => false);

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Text('You are offline'),
            SizedBox(height: 20),
            RaisedButton(
              child: Text('Login'),
              onPressed: () => context.read(loginStatusProvider).state = true,
            ),
          ],
        ),
      ),
    );
  }
}
