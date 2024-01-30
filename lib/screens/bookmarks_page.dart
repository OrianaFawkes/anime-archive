import 'package:flutter/material.dart';
import 'package:anime_archive/screens/search_page.dart';
import 'package:anime_archive/utilities/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:anime_archive/utilities/anime.dart';
import 'package:anime_archive/utilities/database_helper.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  BookmarksPageState createState() => BookmarksPageState();
}

class BookmarksPageState extends State<BookmarksPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Anime> animeList = <Anime>[];
  int count = 0;

  void _delete(BuildContext context, Anime anime) async {
    await databaseHelper.deleteAnime(anime.id);
  }

  void _updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Anime>> animeListFuture = databaseHelper.getAnimeList();
      animeListFuture.then((animeList) {
        setState(() {
          this.animeList = animeList;
          count = animeList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _updateListView();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffe3f6f5),
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Column(
          children: [
            Container(
              height: 64,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: const BoxDecoration(
                color: Color(0xfffffffe),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xff272343),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Anime Archive',
                      style: TextStyle(
                        letterSpacing: -1.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 21.1121,
                        color: Color(0xff272343),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0),
                    child: GestureDetector(
                      onTapUp: (_) {
                        setState(
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SearchPage()),
                            );
                          },
                        );
                      },
                      child: const BookmarksNavBarButton(
                        icon: Icons.search_rounded,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 2.0),
                    child: GestureDetector(
                      onTapUp: (_) {
                        Alert(
                          context: context,
                          title: 'WARNING',
                          content: const Text(
                            'Remove all Archived Anime?',
                            style: TextStyle(
                              letterSpacing: -1.0,
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Color(0xff272343),
                            ),
                          ),
                          style: AlertStyle(
                            alertBorder: Border.all(
                              color: const Color(0xff272343),
                              width: 2.0,
                            ),
                            backgroundColor: const Color(0xfffffffe),
                            isCloseButton: false,
                            overlayColor: const Color(0x77272343),
                            titleStyle: const TextStyle(
                              letterSpacing: -1.0,
                              fontWeight: FontWeight.bold,
                              fontSize: 21.1121,
                              color: Color(0xff272343),
                            ),
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.transparent,
                              border: Border.all(
                                color: const Color(0xff272343),
                                width: 2.0,
                              ),
                              child: const Text(
                                'CANCEL',
                                style: TextStyle(
                                  letterSpacing: -1.0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff272343),
                                ),
                              ),
                            ),
                            DialogButton(
                              onPressed: () {
                                Navigator.pop(context);
                                databaseHelper.deleteAllAnime();
                              },
                              color: const Color(0xffffd803),
                              border: Border.all(
                                color:
                                    const Color(0xff272343), // set border color
                                width: 2.0,
                              ),
                              child: const Text(
                                'REMOVE',
                                style: TextStyle(
                                  letterSpacing: -1.0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xff2d334a),
                                ),
                              ),
                            )
                          ],
                        ).show();
                      },
                      child: const BookmarksNavBarButton(
                        icon: Icons.clear_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: animeList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Center(
                        child: ListView.builder(
                          itemCount: count,
                          itemBuilder: (BuildContext context, int position) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 8.0),
                              child: Container(
                                height: 64,
                                decoration: BoxDecoration(
                                  color: const Color(0xfffffffe),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: const Color(0xff272343),
                                    width: 2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xff2d334a),
                                      offset: Offset(4.0, 4.0),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              animeList[position].aTitleNative,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                letterSpacing: 2.0,
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Color(0xff272343),
                                              ),
                                            ),
                                            Text(
                                              animeList[position].aTitleRomanji,
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.9288,
                                                color: Color(0xff272343),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        child: const Icon(
                                          Icons.clear_rounded,
                                          color: Color(0xff272343),
                                        ),
                                        onTap: () {
                                          _delete(context, animeList[position]);
                                          _updateListView();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Center(
                        child: Text(
                          'No Archived Anime yet. Start by using the "Search" button!\n— Ori',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: -1.0,
                            color: Color(0xff2d334a),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
