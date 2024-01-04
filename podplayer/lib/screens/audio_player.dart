// ignore_for_file: depend_on_referenced_packages

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:podplayer/screens/firebase_fetch.dart';
import 'package:podplayer/screens/showSnack.dart';
import 'package:podplayer/url_provider.dart';
import "package:provider/provider.dart";

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final AudioPlayer audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  String playerUrl = '';

  getUrl() async {
    final String? playurl = await getLatestPost();
    setState(() {
      playerUrl = playurl!;
    });
    // print(playerUrl);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Consumer<URLProvider>(
        builder: (context, urlProv, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                const NeumorphicText(
                  text: "Your Pod is Here",
                  style: TextStyle(fontSize: 18, letterSpacing: 8),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position.toString()),
                      Text((duration - position).toString())
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
              ],
            ),
          );
        },
      ),
    );
  }
}

class NeumorphicCircleAvatar extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPlaying;

  const NeumorphicCircleAvatar({super.key, required this.onPressed, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(8.0, 8.0),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
          boxShadow: [
           const BoxShadow(
              offset: Offset(-5.0, -5.0),
              blurRadius: 10.0,
              color: Colors.white,
            ),
            BoxShadow(
              offset: const Offset(5.0, 5.0),
              blurRadius: 10.0,
              color: Colors.grey.shade500,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.transparent,
          child: IconButton(
            iconSize: 50,
            onPressed: onPressed,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class NeumorphicImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double borderRadius;

  const NeumorphicImage({super.key, 
    required this.imageUrl,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(8.0, 8.0),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-5.0, -5.0),
            blurRadius: 10.0,
            spreadRadius: 5.0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          filterQuality: FilterQuality.high,
          color: Colors.grey.shade400,
          colorBlendMode: BlendMode.colorBurn,
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class NeumorphicText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const NeumorphicText({super.key, required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style.copyWith(
        shadows: [
          Shadow(
            offset: const Offset(5.0, 5.0),
            blurRadius: 10.0,
            color: Colors.grey.shade300,
          ),
          Shadow(
            offset: const Offset(-5.0, -5.0),
            blurRadius: 10.0,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }
}
