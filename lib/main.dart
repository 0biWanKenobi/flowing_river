import 'package:flowing_river/ui/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/screens/favorites_screen.dart';
import 'package:flowing_river/ui/screens/home_screen.dart';
import 'package:flowing_river/ui/screens/images_screen.dart';
import 'package:flowing_river/ui/screens/profile_screen.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        '/profile': (_) => ProfileScreen(),
        '/favorites': (_) => FavoritesScreen(),
        '/images': (_) => ImagesScreen(),
      },
    );
  }
}

class MyHomePage extends HookWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  void _incrementCounter(BuildContext context) {
    context.read(counterProvider).state++;
  }

  @override
  Widget build(BuildContext context) {
    final screen = useProvider(currentScreen);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: IndexedStack(
        index: screen.state,
        children:
            screenList.values.map((appScreen) => appScreen.screen).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _incrementCounter(context),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => screen.state = index,
        unselectedItemColor: Colors.black12,
        showUnselectedLabels: true,
        currentIndex: screen.state,
        items: screenList.values
            .map((appScreen) => BottomNavigationBarItem(
                  icon: Icon(
                    appScreen.iconData,
                    color: Colors.black45,
                  ),
                  title: Text(
                    appScreen.name,
                    style: TextStyle(color: Colors.black45),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
