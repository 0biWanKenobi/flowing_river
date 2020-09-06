import 'package:flowing_river/ui/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/bottom_navigation.dart';

final typeKeySetProvider =
    Provider.autoDispose.family<ScreenKeySet, ScreenType>((ref, type) {
  final keySet = ScreenKeySet(GlobalKey(), GlobalKey<NavigatorState>());
  ref.maintainState = true;
  return keySet;
});

final currentScreenProvider = ScopedProvider<AppScreen>((_) => null);
final currentTypeProvider = ScopedProvider<ScreenType>((_) => null);
final screenProvider = Provider.family<Widget, AppScreen>((ref, screenData) {
  return screenData.authenticated
      ? ref.watch(loginStatusProvider).state
          ? screenData.screen
          : OfflineScreen()
      : screenData.screen;
});

enum KeyType { SubTreeKey, NavigatorKey }

class ScreenKeySet {
  final GlobalKey subTreeKey;
  final GlobalKey<NavigatorState> navigatorKey;

  ScreenKeySet(this.subTreeKey, this.navigatorKey);
}

class ScreenWrapper extends HookWidget {
  const ScreenWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenType = useProvider(currentTypeProvider);
    final screenKeys = useProvider(typeKeySetProvider(screenType));
    final screenData = useProvider(currentScreenProvider);
    // useProvider(screenProvider(screenType));

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
            builder: (ctx) => Consumer(
              builder: (_, watch, __) => watch(screenProvider(screenData)),
            ),
          );
        },
      ),
    );
  }
}
