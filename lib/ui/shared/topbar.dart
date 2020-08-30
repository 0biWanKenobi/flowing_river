import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const double kTopbarExpandedHeight = 300;

class TopBarUiModel {
  final String title;
  final Widget expandedTitle, tabs;
  final bool hasTabs, alwaysShowHeader;

  TopBarUiModel({
    this.title,
    this.expandedTitle,
    this.alwaysShowHeader = false,
    this.tabs,
    this.hasTabs,
  });

  @override
  operator ==(o) => o is TopBarUiModel && o.title == this.title;

  @override
  int get hashCode => title.hashCode;
}

class TopBarStateModel {
  static const kBottomHeight = kTextTabBarHeight + 10;

  final bool hasTabs;
  final ScrollController scrollController;

  final AutoDisposeStateProvider<bool> collapsedStateProvider;

  const TopBarStateModel({
    this.hasTabs = false,
    this.scrollController,
    this.collapsedStateProvider,
  });

  @override
  operator ==(o) =>
      o is TopBarStateModel &&
      o.scrollController == this.scrollController &&
      o.collapsedStateProvider == this.collapsedStateProvider;

  @override
  int get hashCode =>
      scrollController.hashCode ^ collapsedStateProvider.hashCode;
}

final topBarModelProvider = ScopedProvider<TopBarStateModel>((_) => null);
final testProvider = ScopedProvider<String>((_) => null);

class TopBar extends HookWidget {
  const TopBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topBarModel = useProvider(topBarModelProvider);
    final collapsed = useProvider(topBarModel.collapsedStateProvider);

    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: kTopbarExpandedHeight,
      title: collapsed.state
          ? Text('SliverBar')
          : Text(
              'SLIVERBAR SCREEN',
              style: Theme.of(context).textTheme.headline5,
            ),
    );
  }
}
