import 'package:flowing_river/ui/shared/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collapsedStateProvider = StateProvider.autoDispose<bool>((ref) {
  ref.maintainState = true;
  return false;
});
final scrollCtrlProvider = Provider.autoDispose<ScrollController>((ref) {
  ref.maintainState = true;
  return ScrollController();
});
final scrollCtrlListenerProvider =
    Provider.autoDispose.family<ScrollController, bool>((ref, topBarHasTabs) {
  final bottomHeight = topBarHasTabs ? TopBarStateModel.kBottomHeight : 0.0;
  final comparedHeight = kTopbarExpandedHeight - kToolbarHeight - bottomHeight;
  final scrollController = ref.read(scrollCtrlProvider);

  ref.maintainState = true;

  return scrollController
    ..addListener(() => ref.read(collapsedStateProvider).state =
        scrollController.hasClients &&
            (comparedHeight - scrollController.offset) < 0.1);
});

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
            topBarModelProvider.overrideWithValue(
              TopBarStateModel(
                scrollController: scrollController,
                collapsedStateProvider: collapsedStateProvider,
              ),
            )
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
