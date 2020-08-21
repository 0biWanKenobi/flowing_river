import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

const int kImagePageLimit = 30;

// workaround to https://github.com/dart-lang/sdk/issues/41449
final $family = FutureProvider.autoDispose.family;

final imageUrlsProvider = $family<SearchResult, int>((ref, page) async {
  final response = await http
      .get('https://picsum.photos/v2/list?page=$page&limit=$kImagePageLimit');
  final images = json.decode(response.body) as List<dynamic>;
  if (images.isEmpty)
    return SearchResult(
      [],
    );
  else {
    final mappedImages =
        images.map((imgInfo) => (imgInfo as Map<String, dynamic>)).toList();
    ref.read(pageNrProvider).state = page;
    // Once a page was downloaded, preserve its state to avoid re-downloading it again.
    ref.maintainState = true;
    return SearchResult(
      mappedImages.map<String>((e) => e['url'] as String).toList(),
    );
  }
});

final imageUrls = Provider(
  (ref) => ref.watch(imageUrlsProvider(1)).whenData((value) => value),
);

final pageNrProvider = StateProvider<int>((ref) => 1);

final urlsCountProvider =
    FutureProvider.family<int, int>((ref, newValue) => Future.value(newValue));

class SearchResult {
  final List<String> urlList;
  int totalUrlCount(page) => kImagePageLimit * (page - 1) + urlList.length;

  SearchResult(this.urlList);
}

class ImagesScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final int pageNr = useProvider(pageNrProvider).state;

    return useProvider(imageUrls).when(
        data: (searchResult) => Scaffold(
              appBar: AppBar(
                title: Text('Images'),
              ),
              body: ListView.builder(
                itemCount: searchResult.urlList.isNotEmpty
                    ? searchResult.totalUrlCount(pageNr) + 1
                    : searchResult.totalUrlCount(pageNr),
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
  final page = offset ~/ kImagePageLimit + 1;

  return ref.watch(imageUrlsProvider(page)).whenData((value) {
    return value.urlList[offsetInPage];
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
