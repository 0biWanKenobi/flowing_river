import 'package:flowing_river/ui/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthenticatedScreen extends StatelessWidget {
  const AuthenticatedScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticated Page'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text('Hello you are logged in'),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Logout'),
                onPressed: () =>
                    context.read(loginStatusProvider).state = false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
