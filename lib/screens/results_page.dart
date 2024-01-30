import 'package:flutter/material.dart';
import 'package:anime_archive/utilities/constants.dart';
import 'package:anime_archive/utilities/anime.dart';
import 'package:anime_archive/utilities/database_helper.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:video_player/video_player.dart';

class ResultsPage extends StatefulWidget {
  final dynamic animeVideo;
  final dynamic animeTitleNative;
  final dynamic animeTitleRomanji;
  final dynamic animeEpisode;
  final dynamic animeFrom;
  final dynamic animeTo;
  final dynamic animeSimilarity;

  const ResultsPage(
      {super.key,
      this.animeVideo,
      this.animeTitleNative,
      this.animeTitleRomanji,
      this.animeEpisode,
      this.animeFrom,
      this.animeTo,
      this.animeSimilarity});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late VideoPlayerController _controller;
  late Anime anime;

  Future<String> _save() async {
    int id = (await databaseHelper.getCount())! + 1;

    bool isDuplicate = await _checkForDuplicate(widget.animeTitleRomanji);

    if (isDuplicate) {
      return 'Anime already archived!';
    } else {
      anime = Anime(
        id,
        widget.animeTitleNative,
        widget.animeTitleRomanji,
      );

      await databaseHelper.insertAnime(anime);

      return 'Anime archived successfully!';
    }
  }

  Future<bool> _checkForDuplicate(String animeTitleRomanji) async {
    List<Anime> animeList = await databaseHelper.getAnimeList();

    return animeList.any((anime) => anime.aTitleRomanji == animeTitleRomanji);
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.animeVideo))
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, right: 16.0),
                    child: GestureDetector(
                      onTapUp: (_) {
                        setState(
                          () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      child: const SearchNavBarButton(
                        icon: Icons.navigate_before_rounded,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Search Result',
                      style: TextStyle(
                        letterSpacing: -1.0,
                        fontWeight: FontWeight.bold,
                        fontSize: 21.1121,
                        color: Color(0xff272343),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 4.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: const Color(0xff272343),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                                child: _controller.value.isInitialized
                                    ? AspectRatio(
                                        aspectRatio:
                                            _controller.value.aspectRatio,
                                        child: VideoPlayer(_controller),
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Title (Kanji)',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.9288,
                                    color: Color(0xff272343),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Container(
                                  width: double.maxFinite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: Text(
                                    widget.animeTitleNative,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Color(0xff272343),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Title (Romanji)',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.9288,
                                    color: Color(0xff272343),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Container(
                                  width: double.maxFinite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: Text(
                                    widget.animeTitleRomanji,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      letterSpacing: -1.0,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Color(0xff272343),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Timestamp',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.9288,
                                    color: Color(0xff272343),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Container(
                                  width: double.maxFinite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: Text(
                                    'Episode ${widget.animeEpisode}; ${widget.animeFrom} - ${widget.animeTo}',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      letterSpacing: -1.0,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Color(0xff272343),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.maxFinite,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: const Text(
                                  'Similarity',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.9288,
                                    color: Color(0xff272343),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 2.0),
                                child: Container(
                                  width: double.maxFinite,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
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
                                  child: Text(
                                    widget.animeSimilarity,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      letterSpacing: -1.0,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: Color(0xff272343),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 32.0),
                        child: GestureDetector(
                          onTap: () {
                            _save().then((String result) {
                              Alert(
                                context: context,
                                title: "STATUS",
                                content: Text(
                                  result,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
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
                                  isButtonVisible: false,
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
                                    onPressed: () => Navigator.pop(context),
                                    width: 0,
                                    height: 0,
                                    child: null,
                                  )
                                ],
                              ).show();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffffd803),
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
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.archive_rounded,
                                  size: 32.0,
                                  color: Color(0xff272343),
                                ),
                                Text(
                                  '  Archive Anime  ',
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xff2d334a),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
