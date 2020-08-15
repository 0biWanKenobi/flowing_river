import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentFavorite =
    ScopedProvider<FavoriteModel>((_) => throw UnimplementedError());

class FavoriteModel {
  final String name, description;

  FavoriteModel(this.name, this.description);
}
