import 'package:flowing_river/ui/screens/statenotifier_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
            )
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
