import 'package:cloud_firestore/cloud_firestore.dart';

class FileUpload {
  final String nameoftheresource;
  final String bookName;
  final String topic;
  final String classLevel;
  final String description;
  final String edition;
  final String filename; // Changed to String
  final String chapter;
  final String urlType;
  final String resourceUrl;
  final String subjectName;
  final List<String> tags; // List of tags as strings
  final String uid;
  final DateTime? uploadTime; // Nullable uploadTime

  FileUpload({
    required this.nameoftheresource,
    required this.bookName,
    required this.topic,
    required this.classLevel,
    required this.description,
    required this.edition,
    required this.filename, // Expecting String for filename
    required this.chapter,
    required this.urlType,
    required this.resourceUrl,
    required this.subjectName,
    required this.tags, // List of tags
    required this.uid,
    this.uploadTime, // Nullable uploadTime
  });

  factory FileUpload.fromJson(Map<String, dynamic> json) {
    // Log the json to see the actual data
    print('FileUpload fromJson called with data: $json');

    return FileUpload(
      nameoftheresource: json['nameoftheresource'] ?? '',
      bookName: json['bookName'] ?? '',
      topic: json['topic'] ?? '',
      classLevel: json['classLevel'] ?? '',
      description: json['description'] ?? '',
      edition: json['edition'] ?? '',
      filename: json['filename'] ?? '', // Expect a single string for filename
      chapter: json['chapter'] ?? '',
      urlType: json['urlType'] ?? '',
      resourceUrl: json['resourceUrl'] ?? '',
      subjectName: json['subjectName'] ?? '',
      // Handle 'tags': Convert to List<String> whether it's a string or list
      tags: json['tags'] is List
          ? List<String>.from(json['tags']) // If it's already a list
          : [json['tags'] ?? ''], // Wrap string in a list if it's a single tag
      uid: json['uid'] ?? '',
      uploadTime: json['uploadTime'] != null
          ? (json['uploadTime'] as Timestamp).toDate()
          : null, // Nullable uploadTime
    );
  }
}
