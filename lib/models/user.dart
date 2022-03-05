import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String? userID;
  String? email;
  String? username;
  String? phone;
  String? kresAdi;
  String? kresCode;
  bool? isAdmin;
  String? position;
  DateTime? createdAt;

  MyUser({required this.userID, required this.email, this.isAdmin});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'username': username,
      'phone': phone,
      'kresAdi': kresAdi,
      'kresCode;': kresCode,
      'isAdmin': isAdmin ?? false,
      'position': position ?? 'visitor',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        username = map['username'],
        phone = map['phone'],
        kresAdi = map['kresAdi'],
        kresCode = map['kresCode'],
        isAdmin = map['isAdmin'],
        position = map['position'],
        createdAt = (map['createdAt'] as Timestamp).toDate();

  @override
  String toString() {
    return 'User  {userID: $userID, email: $email, username: $username, phone: $phone, kresAdi: $kresAdi, kresCode: $kresCode, isAdmin: $isAdmin, position: $position, createdAt: $createdAt}';
  }
}
