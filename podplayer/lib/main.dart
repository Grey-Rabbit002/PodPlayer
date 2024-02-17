// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:podplayer/controller/firebase_controller.dart';
import 'package:podplayer/provider/url_provider.dart';
import 'package:podplayer/wrapper.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    Provider<FirebaseAuthMethods>(
    create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
  ),
  StreamProvider(
    create: (context) => context.read<FirebaseAuthMethods>().authState,
    initialData: null,
  ),
    ChangeNotifierProvider<URLProvider>(create: (_) => URLProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pod Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const Wrapper()
    );
  }
}
