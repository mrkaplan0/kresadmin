import 'dart:io';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/services/FirebaseAuthServices.dart';
import 'package:kresadmin/services/base/auth_base.dart';
import 'package:kresadmin/services/firestore_db_service.dart';
import 'package:kresadmin/services/storage_service.dart';

import '../locator.dart';

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<MyUser?> currentUser() async {
    var _user = await _firebaseAuthService.currentUser();
    if (_user != null) {
      return await _firestoreDBService.readUser(_user.userID!);
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<bool> updateUser(MyUser user) async {
    return await _firestoreDBService.updateUser(user);
  }

  @override
  Future<MyUser> signingWithEmailAndPassword(String email, String sifre) async {
    MyUser _user =
        await _firebaseAuthService.signingWithEmailAndPassword(email, sifre);
    return await _firestoreDBService.readUser(_user.userID!);
  }

  @override
  Future<MyUser?> createUserEmailAndPassword(String email, String sifre) async {
    MyUser _user =
        await _firebaseAuthService.createUserEmailAndPassword(email, sifre);

    bool _sonuc = await _firestoreDBService.saveUser(_user);
    if (_sonuc) {
      return await _firestoreDBService.readUser(_user.userID!);
    } else {
      return null;
    }
  }

  @override
  Future<bool> deleteUser(MyUser user) async {
    bool _sonuc = await _firebaseAuthService.deleteUser(user);

    return _sonuc;
  }

  @override
  Future<String> queryKresList(String kresCode) async {
    return await _firestoreDBService.queryKresList(kresCode);
  }

  @override
  Future<bool> saveStudent(
      String kresCode, String kresAdi, Student student) async {
    bool checkResult = await _firestoreDBService.checkOgrIDisUseable(student);
    if (checkResult == true) {
      return await _firestoreDBService.saveStudent(kresCode, kresAdi, student);
    } else {
      return await _firestoreDBService.saveStudent(kresCode, kresAdi, student);
    }
  }

  @override
  Future<String> uploadOgrProfilePhoto(
      String kresCode,
      String kresAdi,
      String ogrID,
      String ogrAdi,
      String fileType,
      File yuklenecekDosya) async {
    var url = await _firebaseStorageService.uploadPhoto(
        kresCode, kresAdi, ogrID, fileType, yuklenecekDosya);
    print(url);
    if (url.isNotEmpty) {
      await _firestoreDBService.updateOgrProfilePhoto(
          kresCode, kresAdi, ogrID, url);
    }
    return url;
  }

  @override
  Stream<List<Student>> getStudents(String kresCode, String kresAdi) {
    return _firestoreDBService.getStudents(kresCode, kresAdi);
  }

  @override
  Future<List<Student>> getStudentFuture(
      String kresCode, String kresAdi) async {
    return await _firestoreDBService.getStudentsFuture(kresCode, kresAdi);
  }

  @override
  Future<bool> deleteStudent(
      String kresCode, String kresAdi, Student student) async {
    return await _firestoreDBService.deleteStudent(kresCode, kresAdi, student);
  }

  @override
  Future<bool> deleteTeacher(
      String kresCode, String kresAdi, Teacher teacher) async {
    return await _firestoreDBService.deleteTeacher(kresCode, kresAdi, teacher);
  }

  @override
  Stream<List<Teacher>> getTeachers(String kresCode, String kresAdi) {
    return _firestoreDBService.getTeachers(kresCode, kresAdi);
  }

  @override
  Future<bool> queryOgrID(String kresCode, String kresAdi, String ogrID) async {
    return await _firestoreDBService.queryOgrID(kresCode, kresAdi, ogrID);
  }

  @override
  Future<bool> addCriteria(
      String kresCode, String kresAdi, String criteria) async {
    return await _firestoreDBService.addCriteria(kresCode, kresAdi, criteria);
  }

  @override
  Future<bool> deleteCriteria(
      String kresCode, String kresAdi, String criteria) async {
    return await _firestoreDBService.deleteCriteria(
        kresCode, kresAdi, criteria);
  }

  @override
  Future<List<String>> getCriteria(String kresCode, String kresAdi) async {
    return await _firestoreDBService.getCriteria(kresCode, kresAdi);
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) async {
    return await _firestoreDBService.getRatings(kresCode, kresAdi, ogrID);
  }

  @override
  Future<bool> saveRatings(String kresCode, String kresAdi, String ogrID,
      Map<String, dynamic> ratings, bool showPhotoMainPage) async {
    return await _firestoreDBService.saveRatings(
        kresCode, kresAdi, ogrID, ratings, showPhotoMainPage);
  }

  @override
  Future<String> uploadPhotoToGallery(
      String kresCode,
      String kresAdi,
      String ogrID,
      String ogrAdi,
      String fileType,
      File yuklenecekDosya) async {
    var url = await _firebaseStorageService.uploadPhoto(
        kresCode, kresAdi, ogrID, fileType, yuklenecekDosya);

    return url;
  }

  @override
  Future<bool> deletePhoto(
      String kresCode, String kresAdi, String ogrID, String fotoUrl) async {
    bool b = false;
    bool sonuc = await _firebaseStorageService.deletePhoto(ogrID, fotoUrl);
    if (sonuc == true) {
      bool result = await _firestoreDBService.deletePhoto(
          kresCode, kresAdi, ogrID, fotoUrl);
      b = result;
    }
    return b;
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
      String kresCode, String kresAdi) async {
    return await _firestoreDBService.getPhotoToMainGallery(kresCode, kresAdi);
  }

  @override
  Future<bool> savePhotoToMainGallery(
      String kresCode, String kresAdi, Photo myPhoto) async {
    return await _firestoreDBService.savePhotoToMainGallery(
        kresCode, kresAdi, myPhoto);
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) async {
    return await _firestoreDBService.getPhotoToSpecialGallery(
        kresCode, kresAdi, ogrID);
  }

  @override
  Future<bool> savePhotoToSpecialGallery(
      String kresCode, String kresAdi, Photo myPhoto) async {
    return await _firestoreDBService.savePhotoToSpecialGallery(
        kresCode, kresAdi, myPhoto);
  }

  @override
  Future<bool> addAnnouncement(
      String kresCode, String kresAdi, Map<String, dynamic> map) async {
    return await _firestoreDBService.addAnnouncement(kresCode, kresAdi, map);
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) async {
    return await _firestoreDBService.getAnnouncements(kresCode, kresAdi);
  }
}
