import 'package:flowing_river/ui/bottom_navigation.dart';
import 'package:flowing_river/ui/sliver_appbar_provider_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double kTopbarExpandedHeight = 300;
const kBottomHeight = kTextTabBarHeight + 10;

class TopBarUiModel {
  final String title;
  final Widget expandedTitle, tabs;
  final bool hasTabs, alwaysShowHeader;
  final ScreenType type;

  TopBarUiModel({
    this.title,
    this.expandedTitle,
    this.alwaysShowHeader = false,
    this.tabs,
    this.hasTabs = false,
    this.type,
  });

  @override
  operator ==(o) =>
      o is TopBarUiModel && o.title == this.title && o.type == this.type;

  @override
  int get hashCode => title.hashCode ^ type.hashCode;
}

final topBarUiProvider = ScopedProvider<TopBarUiModel>((_) => null);

class TopBar extends HookWidget {
  const TopBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topBarUi = useProvider(topBarUiProvider);
    final collapsed = useProvider(collapsedStateProvider(topBarUi.type));

    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: kTopbarExpandedHeight,
      title: collapsed.state ? Text(topBarUi.title) : topBarUi.expandedTitle,
      bottom: topBarUi.tabs,
    );
  }
}
