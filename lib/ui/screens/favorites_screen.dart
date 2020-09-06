import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:flowing_river/ui/favorite_widget.dart';
import 'package:flowing_river/models/favorite_model.dart';

final favoritesProvider =
    StateNotifierProvider<FavoriteModelList>((ref) => FavoriteModelList([]));

class FavoriteModelList extends StateNotifier<List<FavoriteModel>> {
  FavoriteModelList(List<FavoriteModel> state) : super(state);
  void add(FavoriteModel f) {
    state = [...state, f];
  }
}

final nameKeyProvider = Provider((_) => UniqueKey());
final descrKeyProvider = Provider((_) => UniqueKey());

class FavoritesScreen extends HookWidget {
  const FavoritesScreen({Key key}) : super(key: key);
  static const title = 'Favorites';

  @override
  Widget build(BuildContext context) {
    final favorites = useProvider(favoritesProvider.state);
    final favoriteNameController = useTextEditingController();
    final favoriteDescriptionController = useTextEditingController();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: TextField(
                key: useProvider(nameKeyProvider),
                controller: favoriteNameController,
                decoration: const InputDecoration(
                  labelText: 'Favorite name',
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: TextField(
                key: useProvider(descrKeyProvider),
                controller: favoriteDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Favorite description',
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                final name = favoriteNameController.value.text;
                final description = favoriteDescriptionController.value.text;
                if (name.isNotEmpty && description.isNotEmpty)
                  context
                      .read(favoritesProvider)
                      .add(FavoriteModel(name, description));
              },
            )
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (_, i) => ProviderScope(
              overrides: [
                currentFavorite.overrideWithValue(favorites[i]),
              ],
              child: const FavoriteWidget(),
            ),
          ),
        ),
      ],
    );
  }
}
