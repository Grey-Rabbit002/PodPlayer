// ignore_for_file: depend_on_referenced_packages
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// fetching the latest post
Future<String?> getLatestPost() async {
  try {
    print("trying");
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('post')
            .orderBy('id', descending: true)
            // Assuming 'timestamp' is the field storing the timestamp
            .limit(1) // Limit the result to only one document
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Get the data of the latest document
      Map<String, dynamic> latestPost = querySnapshot.docs.first.data();
      log(latestPost.toString());
      return latestPost['url'];
    } else {
      return '';
    }
  } catch (e) {
    return '';
  }
}

// fetching all the posts
Future<List<String?>> allPosts() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('post')
        .orderBy('id', descending: true)
        .get();

    List<String?> urls = [];

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        Map<String, dynamic> postData = doc.data();
        urls.add(postData['url']);
      }
      log(urls.length.toString());
      return urls;
    } else {
      return urls;
    }
  } catch (e) {
    return [];
  }
}
