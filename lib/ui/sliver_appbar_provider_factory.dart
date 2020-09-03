import 'package:flowing_river/ui/bottom_navigation.dart' show ScreenType;
import 'package:flowing_river/ui/shared/topbar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef ScrollController ScrollCtrlProviderFunc(
    AutoDisposeProviderReference ref, bool appbarHasTabs);

final collapsedStateProvider =
    StateProvider.autoDispose.family<bool, ScreenType>((ref, type) {
  final status = false;
  ref.maintainState = true;
  return status;
});
final scrollCtrlProvider =
    Provider.autoDispose.family<ScrollController, ScreenType>((ref, type) {
  final controller = ScrollController();
  ref.maintainState = true;
  return controller;
});

ScrollCtrlProviderFunc scrollCtrlProviderFactory(ScreenType type) {
  return (ref, topBarHasTabs) {
    final bottomHeight = topBarHasTabs ? kBottomHeight : 0.0;
    final comparedHeight =
        kTopbarExpandedHeight - kToolbarHeight - bottomHeight;
    final scrollController = ref.read(scrollCtrlProvider(type));

    ref.maintainState = true;

    return scrollController
      ..addListener(() => ref.read(collapsedStateProvider(type)).state =
          scrollController.hasClients &&
              (comparedHeight - scrollController.offset) < 0.1);
  };
}
