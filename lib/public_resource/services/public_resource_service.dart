import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmyn/public_resource/models/public_resource_model.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class ResourceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<FileUpload>> fetchResources() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('fileupload').get();

      // Log the number of documents fetched
      debugPrint('Fetched ${snapshot.docs.length} resources from Firestore.');

      return snapshot.docs.map((doc) {
        // Log each document's data
        debugPrint('Document data: ${doc.data()}');

        return FileUpload.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      // Log the error
      debugPrint('Error fetching resources: $e');
      return []; // Return an empty list in case of an error
    }
  }
}
