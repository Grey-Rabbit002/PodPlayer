// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:podplayer/screens/showSnack.dart';
import 'package:podplayer/url_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickFile extends StatefulWidget {
  const PickFile({super.key});

  @override
  State<PickFile> createState() => _PickFileState();
}

class _PickFileState extends State<PickFile> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future selectFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;
      setState(() {
        pickedFile = result.files.first;
      });
      showSnackBar("file selected", context);
      // print("fileSelected");
    } catch (e) {
      showSnackBar("selection failed", context);
    }
  }

  Future<String?> uploadFile() async {
    if (pickedFile == null) return null;

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    try {
      uploadTask = storage.ref('audio/$path').putFile(file);
      await uploadTask!.whenComplete(() {});
      final urlDownload = await storage.ref('audio/$path').getDownloadURL();
      // print("fileUploaded: $urlDownload");
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('post');
      await collectionRef.add(
          {'url': urlDownload, 'id': DateTime.now().millisecondsSinceEpoch});
      showSnackBar("upload success", context);
      return urlDownload;
    } on FirebaseException catch (e) {
      // print(e.toString());
      debugPrint(e.message);
      showSnackBar("upload failed", context);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlProv = Provider.of<URLProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (pickedFile != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200.withAlpha(190),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 130,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            "File has been selected ",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(pickedFile!.name),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  urlProv.updateUrl('');
                  await selectFile();
                },
                child: const Text("Select File",
                    style: TextStyle(
                        letterSpacing: 2, fontSize: 16, color: Colors.black)),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () async {
                  final String? download = await uploadFile();
                  urlProv.updateUrl(download!);
                  // print(urlProv.url);
                },
                child: const Text(
                  "Upload File ",
                  style: TextStyle(
                      letterSpacing: 2, fontSize: 16, color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              buildProgress(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgress() => uploadTask != null
      ? StreamBuilder<TaskSnapshot>(
          stream: uploadTask!.snapshotEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data!;
              double progress = (data.bytesTransferred.toDouble() /
                  data.totalBytes.toDouble());

              return SizedBox(
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey,
                      color: Colors.amber,
                    ),
                    Center(
                      child: Text(
                        '${(100 * progress).roundToDouble()} %',
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const SizedBox(
                height: 50,
              );
            }
          },
        )
      : const SizedBox();
}
