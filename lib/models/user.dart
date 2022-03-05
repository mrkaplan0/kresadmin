import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? userID;
  String? email;
  String? kresAdi;
  String? kresCode;
  bool? isAdmin;
  String? position;
  DateTime? createdAt;
  Map<String, dynamic>? studentMap;
  MyUser({required this.userID, required this.email, this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'kresAdi': kresAdi,
      'kresCode;': kresCode,
      'isAdmin': isAdmin ?? false,
      'position': position ?? 'visitor',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'myStudent': studentMap,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        kresAdi = map['kresAdi'],
        kresCode = map['kresCode'],
        isAdmin = map['isAdmin'],
        position = map['position'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        studentMap = map['myStudent'];

  @override
  String toString() {
    return 'MyUser{userID: $userID, email: $email, kresAdi: $kresAdi, isAdmin: $isAdmin, position: $position, createdAt: $createdAt}';
  }
}
