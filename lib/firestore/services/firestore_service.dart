import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmyn/dashboard/models/edmyn_resource_model.dart';
import 'package:edmyn/user/models/user_profile_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create
  Future<void> saveUserProfile(UserProfile userProfile) async {
    await _db
        .collection('userrole')
        .doc(userProfile.id)
        .set(userProfile.toMap());
  }

  // Read
  Future<UserProfile?> getUserProfile(String id) async {
    DocumentSnapshot doc = await _db.collection('userrole').doc(id).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Update
  Future<void> updateUserProfile(UserProfile userProfile) async {
    await _db
        .collection('userrole')
        .doc(userProfile.id)
        .update(userProfile.toMap());
  }

  // Delete
  Future<void> deleteUserProfile(String id) async {
    await _db.collection('userrole').doc(id).delete();
  }

  // Get All
  Future<List<UserProfile>> getAllUserProfiles() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('userrole').get();
      return querySnapshot.docs.map((doc) {
        return UserProfile.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching all user profiles: $e');
      return [];
    }
  }

  // Read
  Future<EdmynResource?> getEdmynResource(String id) async {
    DocumentSnapshot doc = await _db.collection('fileupload').doc(id).get();
    if (doc.exists) {
      print(doc.data());
      return EdmynResource.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  Future<EdmynResource?> getEdmynResourceByFilename(String filename) async {
    try {
      print('Fetching document with filename: $filename');
      QuerySnapshot snapshot = await _db
          .collection('fileupload')
          .where('filename', isEqualTo: filename)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = snapshot.docs.first;
        print('Document data: ${doc.data()}');
        return EdmynResource.fromMap(
            doc.data() as Map<String, dynamic>, doc.id);
      } else {
        print('No document found with filename: $filename');
      }
    } catch (e) {
      print('Error fetching document: $e');
    }
    return null;
  }
}
