import 'package:flowing_river/ui/screens/statenotifier_screen.dart';
import 'package:flowing_river/ui/shared/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/screen_wrapper.dart';
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
      home: const MyHomePage(),
      routes: {
        '/profile': (_) => ProfileScreen(),
        '/favorites': (_) => FavoritesScreen(),
        '/images': (_) => ImagesScreen(),
        StateNotifierWidget.routeName: (_) => StateNotifierWidget(),
      },
    );
  }
}

final screenTitleProvider = Provider<String>((ref) {
  final index = ref.watch(AppNav.screenIndexProvider).state;
  return AppNav.screenList[AppNav.ScreenType.values.elementAt(index)].name;
});

class MyHomePage extends HookWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenIndex = useProvider(AppNav.screenIndexProvider).state;
    final screenTitle = useProvider(screenTitleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
      ),
      drawer: SideDrawer(),
      body: IndexedStack(
        index: screenIndex,
        children: AppNav.screenList.values
            .map(
              (el) => ProviderScope(
                overrides: [
                  currentScreenProvider
                      .overrideWithValue(AppNav.screenList[el.type]),
                  currentTypeProvider.overrideWithValue(el.type),
                ],
                child: const ScreenWrapper(),
              ),
            )
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black12,
        showUnselectedLabels: true,
        currentIndex: screenIndex,
        onTap: (index) =>
            context.read(AppNav.screenIndexProvider).state = index,
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
