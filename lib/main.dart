import 'package:anime_archive/screens/bookmarks_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AnimeArchive());
}

class AnimeArchive extends StatelessWidget {
  const AnimeArchive({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anime Archive',
      theme: ThemeData(
        fontFamily: 'Lexend_Mega',
      ),
      home: const BookmarksPage(),
    );
  }
}
