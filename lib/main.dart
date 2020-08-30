import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/screen_builder.dart';
import 'package:flowing_river/ui/bottom_navigation.dart' as AppNav;
import 'package:flowing_river/ui/screens/favorites_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final currentScreen = useProvider(AppNav.currentScreenProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentScreen.state,
        children: AppNav.screenList.values
            .map(
              (el) => ProviderScope(
                overrides: [
                  currentTypeProvider.overrideWithValue(el.type),
                ],
                child: const ScreenBuilder(),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black12,
        showUnselectedLabels: true,
        currentIndex: currentScreen.state,
        onTap: (index) => currentScreen.state = index,
        items: AppNav.screenList.values
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
