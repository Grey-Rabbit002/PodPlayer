import 'package:flutter/material.dart';
import 'package:podplayer/controller/firebase_controller.dart';
import 'package:podplayer/screens/audio_player.dart';
import 'package:podplayer/screens/file_pick.dart';
import 'package:podplayer/utils/showSnack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> handleSignOut() async {
    try {
      if (!mounted) {
        return; // Check if the widget is still mounted after async operation
      }
      await FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.grey.shade100,
            title: Text(
              'Pod Player',
              style: GoogleFonts.dancingScript(
                  letterSpacing: 2,
                  fontSize: 32, // Adjust the font size as needed
                  fontWeight:
                      FontWeight.w400, // Optional, adjust the weight as needed
                  fontStyle:
                      FontStyle.italic // Optional, adjust the color as needed
                  ),
            ),
            actions: [
              IconButton(
                  onPressed: () => handleSignOut(),
                  icon: const Icon(Icons.logout_outlined))
            ],
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
    );
  }
}
