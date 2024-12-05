class EdmynResource {
  String id;
  String subjectName;
  String description;
  String classLevel;
  String urlType;
  String filename;
  String nameoftheresource;
  String bookName;
  String topic;
  String edition;
  String chapter;
  String resourceUrl;
  String resourceName;
  //List<String> tags;

  EdmynResource(
      {required this.id,
      required this.nameoftheresource,
      required this.bookName,
      required this.topic,
      required this.classLevel,
      required this.description,
      required this.edition,
      required this.filename,
      required this.chapter,
      required this.urlType,
      required this.resourceUrl,
      required this.subjectName,
      required this.resourceName
      //required this.tags,
      });

  factory EdmynResource.fromMap(Map<String, dynamic> map, String id) {
    return EdmynResource(
      id: id,
      nameoftheresource: map['nameoftheresource'] ?? '',
      bookName: map['bookName'] ?? '',
      topic: map['topic'] ?? '',
      classLevel: map['class'] ?? '',
      description: map['description'] ?? '',
      edition: map['edition'] ?? '',
      filename: map['filename'] ?? '',
      chapter: map['chapter'] ?? '',
      urlType: map['urlType'] ?? '',
      resourceUrl: map['resourceUrl'] ?? '',
      subjectName: map['subjectName'] ?? '',
      resourceName: map['resourceName'] ?? '',
      //tags           : map['tags'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nameoftheresource': nameoftheresource,
      'bookName': bookName,
      'topic': topic,
      'class': classLevel,
      'description': description,
      'edition': edition,
      'filename': filename,
      'chapter': chapter,
      'urlType': urlType,
      'resourceUrl': resourceUrl,
      'subjectName': subjectName,
      'resourceName': resourceName,
      //'tags'           : tags
    };
  }
}
