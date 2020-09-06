import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final loginStatusProvider = StateProvider((_) => false);

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('You are offline'),
                SizedBox(height: 20),
                RaisedButton(
                  child: Text('Login'),
                  onPressed: () =>
                      context.read(loginStatusProvider).state = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
