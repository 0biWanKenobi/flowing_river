import 'package:flowing_river/ui/bottom_navigation.dart';
import 'package:flowing_river/ui/screen_wrapper.dart';
import 'package:flowing_river/ui/screens/statenotifier_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SideDrawer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _MenuOption(
              Text('StateNotifier'),
              icon: Icons.folder_open,
              onTap: () => Navigator.of(context)
                  .pushNamed(StateNotifierWidget.routeName),
              selected: true,
            ),
            _MenuOption(
              Text('Authenticated'),
              icon: Icons.lock_outline,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProviderScope(
                    overrides: [
                      currentTypeProvider
                          .overrideWithValue(ScreenType.Authenticated)
                    ],
                    child: ScreenWrapper(),
                  ),
                ),
              ),
              selected: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon;
  final Widget title;
  final Function() onTap;
  final bool selected;

  const _MenuOption(this.title, {Key key, this.icon, this.onTap, this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: title,
        onTap: onTap,
        selected: selected,
      ),
    );
  }
}
