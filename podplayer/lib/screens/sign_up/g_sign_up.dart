// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:podplayer/constants/app_colors.dart';
import 'package:podplayer/controller/firebase_controller.dart';
import 'package:podplayer/utils/neo_container.dart';
import 'package:podplayer/utils/showSnack.dart';
import 'package:google_fonts/google_fonts.dart';

class GSignUp extends StatefulWidget {
  const GSignUp({super.key});

  @override
  State<GSignUp> createState() => _GSignUpState();
}

class _GSignUpState extends State<GSignUp> {
  Future<void> handleSignIn() async {
    try {
      // Check if the widget is still mounted

      log("sign in");

      final usercred = await FirebaseAuthMethods(FirebaseAuth.instance)
          .signInWithGoogle(context);

      if (!mounted) {
        return; // Check if the widget is still mounted after async operation
      }

      if (usercred == null || usercred.user == null) {
        showSnackBar("Error signing in", context);
        return;
      }
      log("signed in successfully");
    } catch (error) {
      log("Sign in error: $error");
      showSnackBar("Error: $error", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: handleSignIn,
                  child: NeormphContainer(
                    size: size.width * 0.8,
                    blur: 20,
                    distance: 10,
                    imageUrl: 'assets/glogo.png',
                    child: const SizedBox(),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Continue with Google",
                  style: GoogleFonts.quando(
                      fontSize: 32, fontStyle: FontStyle.italic),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
