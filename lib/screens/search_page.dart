import 'package:flutter/material.dart';
import 'package:anime_archive/utilities/constants.dart';
import 'package:anime_archive/screens/results_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isLoading = false;
  String searchURL = "";
  String animeData = "";
  late File _image;

  dynamic animeVideo;
  dynamic animeTitleNative;
  dynamic animeTitleRomanji;
  dynamic animeEpisode;
  dynamic animeFrom;
  dynamic animeTo;
  dynamic animeSimilarity;

  _imgFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(() {
      _image = File(pickedFile!.path);
      isLoading = true;
    });
  }

  _getResultFromGallery() async {
    Dio dio = Dio();
    try {
      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(_image.path),
      });
      var response = await dio.post(
        'https://api.trace.moe/search?anilistInfo',
        data: formData,
      );
      animeData = response.toString();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  getResultFromURL(String url) async {
    Dio dio = Dio();
    try {
      var response =
          await dio.get('https://api.trace.moe/search?anilistInfo&url=$url');
      animeData = response.toString();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String intToTime(int value) {
    if (value == -1) {
      return "00:00:00";
    }
    int h, m, s;
    h = value ~/ 3600;
    m = ((value - h * 3600)) ~/ 60;
    s = value - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0$s" : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";
    return result;
  }

  void convertData() {
    animeTitleNative = jsonDecode(animeData)['result'][0]['anilist']['title']
            ['native'] ??
        'Null';

    animeTitleRomanji = jsonDecode(animeData)['result'][0]['anilist']['title']
            ['romaji'] ??
        'Null';

    animeEpisode = jsonDecode(animeData)['result'][0]['episode'] ?? 'Null';

    animeFrom = jsonDecode(animeData)['result'][0]['from'] ?? -1;
    animeFrom = intToTime(animeFrom.round());

    animeTo = jsonDecode(animeData)['result'][0]['to'] ?? -1;
    animeTo = intToTime(animeTo.round());

    animeSimilarity = jsonDecode(animeData)['result'][0]['similarity'] ?? 0;
    animeSimilarity = '${(animeSimilarity * 100).toStringAsFixed(2)}%';

    animeVideo = jsonDecode(animeData)['result'][0]['video'] ?? 'No Video';
  }

  void _showPicker(context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xffbae8e8),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    size: 24.0,
                    color: Color(0xff272343),
                  ),
                  title: const Text(
                    'Photo Library',
                    style: TextStyle(
                      letterSpacing: -1.0,
                      fontSize: 16,
                      color: Color(0xff2d334a),
                    ),
                  ),
                  onTap: () async {
                    await _imgFromGallery();
                    Navigator.of(context).pop();
                    await _getResultFromGallery();
                    convertData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(
                          animeVideo: animeVideo,
                          animeTitleNative: animeTitleNative,
                          animeTitleRomanji: animeTitleRomanji,
                          animeEpisode: animeEpisode,
                          animeFrom: animeFrom,
                          animeTo: animeTo,
                          animeSimilarity: animeSimilarity,
                        ),
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xffe3f6f5),
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                _focusNode.unfocus();
              },
              child: Column(
                children: [
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                            'Anime Search',
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 64,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, bottom: 4.0, right: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        _showPicker(context);
                                      },
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffd803),
                                            borderRadius:
                                                BorderRadius.circular(8.0),
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
                                          child: const Icon(
                                            Icons.image_rounded,
                                            size: 32.0,
                                            color: Color(0xff272343),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 4.0,
                                          left: 8.0,
                                          right: 8.0),
                                      child: Container(
                                        height: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: const Color(0xfffffffe),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
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
                                        child: Center(
                                          child: TextField(
                                            controller: _textController,
                                            focusNode: _focusNode,
                                            style: const TextStyle(
                                              color: Color(0xff272343),
                                            ),
                                            decoration: InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                              hintText: 'Paste URL Here',
                                              hintStyle: const TextStyle(
                                                color: Color(0x77272343),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 8.0,
                                                      top: 12.0,
                                                      bottom: 12.0),
                                              suffixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.navigate_next_rounded,
                                                  color: Color(0xff272343),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await getResultFromURL(
                                                      searchURL);
                                                  convertData();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResultsPage(
                                                        animeVideo: animeVideo,
                                                        animeTitleNative:
                                                            animeTitleNative,
                                                        animeTitleRomanji:
                                                            animeTitleRomanji,
                                                        animeEpisode:
                                                            animeEpisode,
                                                        animeFrom: animeFrom,
                                                        animeTo: animeTo,
                                                        animeSimilarity:
                                                            animeSimilarity,
                                                      ),
                                                    ),
                                                  );
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                              ),
                                            ),
                                            onChanged: (value) {
                                              searchURL = value;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff272343),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'Anime Archive makes use of trace.moe API to trace back the scene where an anime screenshot is taken from',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.9288,
                                    color: Color(0xfffffffe),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff272343),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'For more accurate results, use unmodified and uncropped images',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.9288,
                                    color: Color(0xfffffffe),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 16.0),
                              child: Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xff272343),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'If the result is inaccurate, it is possible that: '
                                  '\n• The image is not an original anime screenshot'
                                  '\n• The image has been modified'
                                  '\n• The anime is recent and is not yet in the database',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    letterSpacing: -1.0,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.9288,
                                    color: Color(0xfffffffe),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                color: const Color(0x77272343),
                child: const Center(
                  child: SpinKitPulsingGrid(
                    color: Color(0xffbae8e8),
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
