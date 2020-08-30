import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/bottom_navigation.dart';

final Map<ScreenType, ScreenKeySet> typeKeySet = {
  ScreenType.Favorites: ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>()),
  ScreenType.Home: ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>()),
  ScreenType.Images: ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>()),
  ScreenType.Profile: ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>()),
  ScreenType.Sliver: ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>()),
};

final currentTypeProvider =
    ScopedProvider<ScreenType>((ref) => throw UnimplementedError());

enum KeyType { SubTreeKey, NavigatorKey }

class ScreenKeySet {
  final GlobalKey subTreeKey;
  final GlobalKey<NavigatorState> navigatorKey;

  ScreenKeySet(this.subTreeKey, this.navigatorKey);
}

class ScreenBuilder extends HookWidget {
  const ScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screeenType = useProvider(currentTypeProvider);
    final screenKeys = typeKeySet[screeenType];

    return KeyedSubtree(
      key: screenKeys.subTreeKey,
      child: Navigator(
        // The key enables us to access the Navigator's state inside the
        // onWillPop callback and for emptying its stack when a tab is
        // re-selected. That is why a GlobalKey is needed instead of
        // a simpler ValueKey.
        key: screenKeys.navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => screenList[screeenType].screen,
          );
        },
      ),
    );
  }
}
