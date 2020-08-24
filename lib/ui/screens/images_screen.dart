import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

const int kImagePageLimit = 30;

// workaround to https://github.com/dart-lang/sdk/issues/41449
final $family = FutureProvider.autoDispose.family;

final imageUrlsProvider = $family<List<String>, int>((ref, page) async {
  final response = await http
      .get('https://picsum.photos/v2/list?page=$page&limit=$kImagePageLimit');
  final images = json.decode(response.body) as List<dynamic>;

  final hasMore = response.headers['link'].contains('next');
  final mappedImages =
      images.map((imgInfo) => (imgInfo as Map<String, dynamic>)).toList();
  ref.read(statusProvider).state =
      CurrentStatus(hasMore, mappedImages.length, page);
  // Once a page was downloaded, preserve its state to avoid re-downloading it again.
  ref.maintainState = true;
  return mappedImages.map<String>((e) => e['url'] as String).toList();
});

final imageUrls = Provider(
  (ref) => ref.watch(imageUrlsProvider(1)).whenData((value) => value),
);

final statusProvider = StateProvider<CurrentStatus>((ref) => null);

class CurrentStatus {
  final bool _hasMore;
  final int _resultCount, _page;

  CurrentStatus(this._hasMore, this._resultCount, this._page);

  int get totalUrlCount =>
      kImagePageLimit * (_page - 1) + _resultCount + 1 * (_hasMore ? 1 : 0);
}

class ImagesScreen extends HookWidget {
  const ImagesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CurrentStatus status = useProvider(statusProvider).state;

    return useProvider(imageUrls).when(
        data: (searchResult) => Scaffold(
              appBar: AppBar(
                title: Text('Images'),
              ),
              body: ListView.builder(
                itemCount: status.totalUrlCount,
                itemBuilder: (_, i) => ProviderScope(
                  overrides: [imageIndex.overrideWithValue(i)],
                  child: const ImageListTile(),
                ),
              ),
            ),
        loading: () => Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        error: (err, stack) => Text('Error $err'));
  }
}

final urlAtIndex = Provider.family<AsyncValue<String>, int>((ref, offset) {
  final offsetInPage = offset % kImagePageLimit;
  final page = offset ~/ kImagePageLimit + 1;

  return ref.watch(imageUrlsProvider(page)).whenData((value) {
    return value[offsetInPage];
  });
});

final ScopedProvider<int> imageIndex =
    ScopedProvider((_) => throw UnimplementedError());

class ImageListTile extends HookWidget {
  const ImageListTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int index = useProvider(imageIndex);
    final url = useProvider(urlAtIndex(index));
    return url.when(
      data: (url) => Card(
        child: ListTile(
          title: Text(
            'nr: $index: $url',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text('Error $err'),
    );
  }
}
