// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:podplayer/screens/audio_player.dart';
import 'package:podplayer/screens/file_pick.dart';
import 'package:podplayer/url_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<URLProvider>(create: (_) => URLProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.grey.shade100,
              title: const Text(
                'Pod Player',
                style: TextStyle(
                    letterSpacing: 2,
                    fontSize: 24, // Adjust the font size as needed
                    fontWeight: FontWeight
                        .w400, // Optional, adjust the weight as needed
                    fontStyle:
                        FontStyle.italic // Optional, adjust the color as needed
                    ),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.music_note), text: 'Audio Player'),
                  Tab(icon: Icon(Icons.file_upload), text: 'File Picker'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                Player(), // Your Audio Player screen
                PickFile(), // Your File Picker screen
              ],
            ),
          ),
        ),
      ),
    );
  }
}
