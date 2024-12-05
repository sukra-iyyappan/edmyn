class UserProfile {
  String id;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String phoneNumber;
  String? gstNo;
  String city;
  String state;
  String? country;
  String? pincode;
  String? role;
  //String? coachingInstituteName;
  //List<dynamic>? cateringTo;
  String? uid;
  String? address;
  String? idNo;
  String? institution;
  //String? publishingFor;
  //String? publishingHouse;
  // String? subject;
  String? whichClass;
  final bool profileCompleted; // Add this flag


  UserProfile({
    required this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    required this.phoneNumber,
    this.gstNo,
    required this.city,
    required this.state,
    this.country,
    this.pincode,
    this.role,
    // this.coachingInstituteName,
    // this.cateringTo,
    this.uid,
    this.address,
    this.idNo,
    this.institution,
    // this.publishingFor,
    // this.publishingHouse,
    // this.subject,
    this.whichClass,
    this.profileCompleted = false,

  });

  // Factory constructor to create a UserProfile from a Map
  factory UserProfile.fromMap(Map<String, dynamic> map, String id) {
    return UserProfile(
      id: id,
      name: map['name'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] as String?,
      phoneNumber: map['phoneNumber'] ?? '',
      gstNo: map['gstNo'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      country: map['country'] ?? '',
      pincode: map['pincode'] ?? '',
      role: map['role'] ?? '',
      // coachingInstituteName: map['coachingInstituteName'] ?? '',
      // // Handle 'cateringTo' when it's either a List or String
      // cateringTo: map['cateringTo'] is String
      //     ? [map['cateringTo'] as String]
      //     : (map['cateringTo'] as List<dynamic>?)
      //             ?.map((item) => item as String)
      //             .toList() ??
      //         [],
      uid: map['uid'] ?? '',
      address: map['address'] ?? '',
      idNo: map['idNo'] ?? '',
      institution: map['institution'] ?? '',
      // publishingFor: map['publishingFor'] ?? '',
      // publishingHouse: map['publishingHouse'] ?? '',
      // subject: map['subject'] ?? '',
      whichClass: map['whichClass'] ?? null,

    );
  }

  // Convert a UserProfile to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'gstNo': gstNo,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'role': role,
      // 'coachingInstituteName': coachingInstituteName,
      // 'cateringTo': cateringTo,
      'uid': uid,
      'address': address,
      'idNo': idNo,
      'institution': institution,
      // 'publishingFor': publishingFor,
      // 'publishingHouse': publishingHouse,
      // 'subject': subject,
      'whichClass': whichClass,
    };
  }
}
