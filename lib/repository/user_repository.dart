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
  Future<MyUser?> signingWithAnonymously() async {
    return await _firebaseAuthService.signingWithAnonymously();
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
  Future<bool> saveStudent(Student student) async {
    bool checkResult = await _firestoreDBService.checkOgrIDisUseable(student);
    if (checkResult == true) {
      return await _firestoreDBService.saveStudent(student);
    } else {
      return await _firestoreDBService.saveStudent(student);
    }
  }

  @override
  Future<String> uploadOgrProfilePhoto(String ogrID, String ogrAdi,
      String fileType, File yuklenecekDosya) async {
    var url = await _firebaseStorageService.uploadPhoto(
        ogrID, ogrAdi, fileType, yuklenecekDosya);
    if (url.isNotEmpty) {
      await _firestoreDBService.updateOgrProfilePhoto(ogrID, url);
    }
    return url;
  }

  @override
  Stream<List<Student>> getStudents() {
    return _firestoreDBService.getStudents();
  }

  @override
  Future<List<Student>> getStudentFuture() async {
    return await _firestoreDBService.getStudentsFuture();
  }

  @override
  Future<bool> deleteStudent(Student student) async {
    return await _firestoreDBService.deleteStudent(student);
  }

  @override
  Future<bool> saveTeacher(Teacher teacher) async {
    return await _firestoreDBService.saveTeacher(teacher);
  }

  @override
  Future<bool> deleteTeacher(Teacher teacher) async {
    return await _firestoreDBService.deleteTeacher(teacher);
  }

  @override
  Stream<List<Teacher>> getTeachers() {
    return _firestoreDBService.getTeachers();
  }

  @override
  Future<bool> ogrNoControl(String ogrNo) async {
    return await _firestoreDBService.ogrNoControl(ogrNo);
  }

  @override
  Future<bool> addCriteria(String criteria) async {
    return await _firestoreDBService.addCriteria(criteria);
  }

  @override
  Future<bool> deleteCriteria(String criteria) async {
    return await _firestoreDBService.deleteCriteria(criteria);
  }

  @override
  Future<List<String>> getCriteria() async {
    return await _firestoreDBService.getCriteria();
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(String ogrID) async {
    return await _firestoreDBService.getRatings(ogrID);
  }

  @override
  Future<bool> saveRatings(String ogrID, Map<String, dynamic> ratings,
      bool showPhotoMainPage) async {
    return await _firestoreDBService.saveRatings(
        ogrID, ratings, showPhotoMainPage);
  }

  @override
  Future<String> uploadPhotoToGallery(String ogrID, String ogrAdi,
      String fileType, File yuklenecekDosya) async {
    var url = await _firebaseStorageService.uploadPhoto(
        ogrID, ogrAdi, fileType, yuklenecekDosya);

    return url;
  }

  @override
  Future<bool> deletePhoto(String ogrID, String fotoUrl) async {
    bool b = false;
    bool sonuc = await _firebaseStorageService.deletePhoto(ogrID, fotoUrl);
    if (sonuc == true) {
      bool result = await _firestoreDBService.deletePhoto(ogrID, fotoUrl);
      b = result;
    }
    return b;
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery() async {
    return await _firestoreDBService.getPhotoToMainGallery();
  }

  @override
  Future<bool> savePhotoToMainGallery(Photo myPhoto) async {
    return await _firestoreDBService.savePhotoToMainGallery(myPhoto);
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID) async {
    return await _firestoreDBService.getPhotoToSpecialGallery(ogrID);
  }

  @override
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto) async {
    return await _firestoreDBService.savePhotoToSpecialGallery(myPhoto);
  }

  @override
  Future<bool> addAnnouncement(Map<String, dynamic> map) async {
    return await _firestoreDBService.addAnnouncement(map);
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    return await _firestoreDBService.getAnnouncements();
  }
}
