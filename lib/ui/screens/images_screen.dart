import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

const int kImagePageLimit = 30;

// workaround to https://github.com/dart-lang/sdk/issues/41449
final $family = FutureProvider.autoDispose.family;

final imageUrls = $family<SearchResult, int>((ref, page) async {
  final response = await http
      .get('https://picsum.photos/v2/list?page=$page&limit=$kImagePageLimit');
  final images = json.decode(response.body) as List<dynamic>;
  if (images.isEmpty)
    return SearchResult(
      page,
      [],
    );
  else {
    final mappedImages =
        images.map((imgInfo) => (imgInfo as Map<String, dynamic>)).toList();

    // Once a page was downloaded, preserve its state to avoid re-downloading it again.
    ref.maintainState = true;
    return SearchResult(
      page,
      mappedImages.map<String>((e) => e['url'] as String).toList(),
    );
  }
});

final imagePageCount = Provider(
  (ref) => ref.watch(imageUrls(0)).whenData((value) => value.totalUrlCount),
);

class SearchResult {
  final int page;
  final List<String> urlList;
  int get totalUrlCount => kImagePageLimit * page + urlList.length;

  SearchResult(this.page, this.urlList);
}

class ImagesScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return useProvider(imagePageCount).when(
        data: (count) => Scaffold(
              appBar: AppBar(
                title: Text('Images'),
              ),
              body: ListView.builder(
                // itemCount: count,
                itemBuilder: (_, i) {
                  return ProviderScope(
                    overrides: [imageIndex.overrideWithValue(i)],
                    child: const ImageListTile(),
                  );
                },
              ),
            ),
        loading: () => Center(
              child: CircularProgressIndicator(),
            ),
        error: (err, stack) => Text('Error $err'));
  }
}

final urlAtIndex = Provider.family<AsyncValue<String>, int>((ref, offset) {
  final offsetInPage = offset % kImagePageLimit;
  final page = offset ~/ kImagePageLimit;

  return ref
      .watch(imageUrls(page))
      .whenData((value) => value.urlList[offsetInPage]);
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
