// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podplayer/controller/firebase_fetch.dart';
import 'package:podplayer/neomorphs/neocircleAvatar.dart';
import 'package:podplayer/neomorphs/neoimage.dart';
import 'package:podplayer/neomorphs/neotext.dart';
import 'package:podplayer/utils/showSnack.dart';
import 'package:google_fonts/google_fonts.dart';

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> with WidgetsBindingObserver {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  late String playerUrl = '';
  List<String?>? urls = [];
  int selectedIndex = -1;

  getUrl() async {
    final String? playurl = await getLatestPost();
    final List<String?> url = await allPosts();
    setState(() {
      playerUrl = playurl!;
      urls = url;
    });
    log(playerUrl);
  }

  @override
  void initState() {
    super.initState();
    getUrl();
    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        duration = updatedDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });

    // Listen to app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Remove the observer
    WidgetsBinding.instance.removeObserver(this);
    // Stop any ongoing playback and release resources
    audioPlayer.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // When the app is paused or inactive, stop audio playback
      audioPlayer.stop();
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    }
  }

  String formattedDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            NeumorphicText(
              text: "Your Pod is Here",
              style: GoogleFonts.marcellusSc(fontSize: 18, letterSpacing: 8),
            ),
            const SizedBox(
              height: 20,
            ),
            const NeumorphicImage(
              imageUrl:
                  "https://images.unsplash.com/photo-1571330735066-03aaa9429d89?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              height: 200,
              borderRadius: 20,
            ),
            Slider(
              activeColor: Colors.black45,
              thumbColor: Colors.grey,
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  position = Duration(seconds: value.toInt());
                });
              },
              onChangeEnd: (value) {
                audioPlayer.seek(position);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedDuration(position)),
                  Text(formattedDuration(duration)),
                ],
              ),
            ),
            NeumorphicCircleAvatar(
              onPressed: () async {
                if (isPlaying) {
                  setState(() {
                    isPlaying = false;
                  });
                  await audioPlayer.pause();
                } else {
                  if (playerUrl.isNotEmpty) {
                    setState(() {
                      isPlaying = true;
                    });
                    await audioPlayer.play(UrlSource(playerUrl));
                  } else {
                    showSnackBar("no file found", context);
                  }
                }
              },
              isPlaying: isPlaying,
            ),
            const SizedBox(
              height: 40,
            ),
            if (urls != null && urls!.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: urls!.length,
                  itemBuilder: (context, index) {
                    final trimmedTitle = urls![index]!.length > 150
                        ? '${urls![index]!.substring(80, 110)}...'
                        : urls![index]!;

                    return GestureDetector(
                      onTap: () async {
                        await audioPlayer.stop();
                        setState(() {
                          playerUrl = urls![index]!;
                          isPlaying = false;
                          selectedIndex = index;
                        });
                        await audioPlayer.play(UrlSource(playerUrl));
                        setState(() {
                          isPlaying = true;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                trimmedTitle,
                                style: GoogleFonts.gabriela(fontSize: 16),
                              ),
                            ),
                            if (selectedIndex == index)
                              const Icon(
                                Icons.music_note_rounded,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
