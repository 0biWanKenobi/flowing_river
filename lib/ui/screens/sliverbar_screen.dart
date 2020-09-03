import 'package:flowing_river/ui/bottom_navigation.dart' show ScreenType;
import 'package:flowing_river/ui/shared/topbar.dart';
import 'package:flowing_river/ui/sliver_appbar_provider_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final scrollCtrlListenerProvider = Provider.autoDispose
    .family<ScrollController, bool>(
        scrollCtrlProviderFactory(ScreenType.Sliver));

class SliverScreen extends HookWidget {
  const SliverScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = useProvider(scrollCtrlListenerProvider(false));

    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (_, innerBoxScrolled) => [
        ProviderScope(
          overrides: [
            topBarUiProvider.overrideWithValue(
              TopBarUiModel(
                type: ScreenType.Sliver,
                title: 'SliverBar Screen',
                expandedTitle: Text(
                  'SLIVERBAR SCREEN',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ],
          child: const TopBar(),
        )
      ],
      body: ListView.builder(
        itemBuilder: (_, i) => const Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text('some text'),
          ),
        ),
      ),
    );
  }
}
