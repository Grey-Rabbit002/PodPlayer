// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';

Future<String?> getLatestPost() async {
  try {
    // print("trying");
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
      // print(latestPost);
      return latestPost['url'];
    } else {
      // No documents found
      // showSnackBar("database error", context);
      return '';
    }
  } catch (e) {
    // showSnackBar("Firebase error", context);
    // print('Error getting latest post: $e');
    return '';
  }
}
