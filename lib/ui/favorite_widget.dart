import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/models/favorite_model.dart' show currentFavorite;

class FavoriteWidget extends HookWidget {
  const FavoriteWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favorite = useProvider(currentFavorite);
    return Card(
      child: ListTile(
        title: Text(favorite.name),
        subtitle: Text(favorite.description),
        trailing: IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
      ),
    );
  }
}
