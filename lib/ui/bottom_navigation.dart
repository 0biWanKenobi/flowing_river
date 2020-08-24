import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flowing_river/ui/screens/favorites_screen.dart';
import 'package:flowing_river/ui/screens/home_screen.dart';
import 'package:flowing_river/ui/screens/images_screen.dart';
import 'package:flowing_river/ui/screens/profile_screen.dart';

enum ScreenType { Home, Favorites, Images, Profile }

class AppScreen {
  final ScreenType type;
  final String name;
  final Widget screen;
  final IconData iconData;

  const AppScreen(this.type, this.name, this.iconData, this.screen);
}

final Map<ScreenType, AppScreen> screenList = {
  ScreenType.Home:
      const AppScreen(ScreenType.Home, 'Home', Icons.home, HomeScreen()),
  ScreenType.Favorites: AppScreen(ScreenType.Favorites, 'Favorites',
      Icons.favorite_border, FavoritesScreen()),
  ScreenType.Images:
      const AppScreen(ScreenType.Images, 'Images', Icons.image, ImagesScreen()),
  ScreenType.Profile: const AppScreen(
      ScreenType.Profile, 'Profile', Icons.person, ProfileScreen()),
};

final currentScreenProvider = StateProvider<int>((ref) => 0);
