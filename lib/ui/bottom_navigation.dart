import 'package:flowing_river/ui/screens/sliverbar_screen.dart';
import 'package:flowing_river/ui/screens/sliverbar_screen_sibling.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/screens/favorites_screen.dart';
import 'package:flowing_river/ui/screens/home_screen.dart';
import 'package:flowing_river/ui/screens/images_screen.dart';
import 'package:flowing_river/ui/screens/profile_screen.dart';

enum ScreenType {
  Home,
  Favorites,
  Images,
  Profile,
  Sliver,
  Sliver2,
  Authenticated
}

class AppScreen {
  final ScreenType type;
  final String name;
  final Widget screen;
  final IconData iconData;
  final bool authenticated;

  const AppScreen(
    this.type,
    this.name,
    this.iconData,
    this.screen, {
    this.authenticated = false,
  });
}

final Map<ScreenType, AppScreen> screenList = const {
  ScreenType.Home: AppScreen(ScreenType.Home, 'Home', Icons.home, HomeScreen()),
  ScreenType.Favorites: AppScreen(ScreenType.Favorites, 'Favorites',
      Icons.favorite_border, FavoritesScreen()),
  ScreenType.Images:
      AppScreen(ScreenType.Images, 'Images', Icons.image, ImagesScreen()),
  ScreenType.Profile:
      AppScreen(ScreenType.Profile, 'Profile', Icons.person, ProfileScreen()),
  ScreenType.Sliver:
      AppScreen(ScreenType.Sliver, 'Sliver', Icons.expand_more, SliverScreen()),
  ScreenType.Sliver2: AppScreen(
      ScreenType.Sliver2, 'Sliver 2', Icons.expand_more, SliverBarSibling()),
};

final screenIndexProvider = StateProvider<int>((ref) => 0);
