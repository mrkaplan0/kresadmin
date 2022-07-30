import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/services/base/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<MyUser?> currentUser() async {
    try {
      User? user = _auth.currentUser;

      return _usersFromFirebase(user!);
    } catch (e) {
      debugPrint("Hata CurrentUser $e");
      return null;
    }
  }

  MyUser _usersFromFirebase(User user) {
    return MyUser(userID: user.uid, email: user.email!);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      debugPrint("Hata SignOut $e");
      return false;
    }
  }

  @override
  Future<MyUser> signingWithEmailAndPassword(String email, String sifre) async {
    UserCredential sonuc =
        await _auth.signInWithEmailAndPassword(email: email, password: sifre);

    return _usersFromFirebase(sonuc.user!);
  }

  @override
  Future<MyUser> createUserEmailAndPassword(String email, String sifre) async {
    UserCredential sonuc = await _auth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _usersFromFirebase(sonuc.user!);
  }

  @override
  Future<String> uploadOgrProfilePhoto(String kresCode, String kresAdi,
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya) {
    // TODO: implement uploadOgrProfilePhoto
    throw UnimplementedError();
  }

  @override
  Future<bool> saveStudent(String kresCode, String kresAdi, Student student) {
    // TODO: implement saveStudent
    throw UnimplementedError();
  }

  @override
  Stream<List<Student>> getStudents(
    String kresCode,
    String kresAdi,
  ) {
    // TODO: implement getStudents
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteStudent(String kresCode, String kresAdi, Student student) {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTeacher(String kresCode, String kresAdi, Teacher teacher) {
    // TODO: implement deleteTeacher
    throw UnimplementedError();
  }

  @override
  Stream<List<Teacher>> getTeachers(
    String kresCode,
    String kresAdi,
  ) {
    // TODO: implement getTeachers
    throw UnimplementedError();
  }

  @override
  Future<List<Student>> getStudentFuture(
    String kresCode,
    String kresAdi,
  ) async {
    // TODO: implement getStudentFuture
    throw UnimplementedError();
  }

  @override
  Future<bool> addCriteria(String kresCode, String kresAdi, String criteria) {
    // TODO: implement addCriteria
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCriteria(
      String kresCode, String kresAdi, String criteria) {
    // TODO: implement deleteCriteria
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getCriteria(
    String kresCode,
    String kresAdi,
  ) {
    // TODO: implement getCriteria
    throw UnimplementedError();
  }

  @override
  Future<bool> deletePhoto(
      String kresCode, String kresAdi, String ogrID, String fotoUrl) {
    // TODO: implement deletePhoto
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) {
    // TODO: implement getRatings
    throw UnimplementedError();
  }

  @override
  Future<bool> saveRatings(String kresCode, String kresAdi, String ogrID,
      Map<String, dynamic> ratings, bool showPhotoMainPage) {
    // TODO: implement saveRatings
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPhotoToGallery(String kresCode, String kresAdi,
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya) {
    // TODO: implement uploadPhotoToGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
    String kresCode,
    String kresAdi,
  ) {
    // TODO: implement getPhotoToMainGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> savePhotoToMainGallery(
      String kresCode, String kresAdi, Photo myPhoto) {
    // TODO: implement savePhotoToMainGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) {
    // TODO: implement getPhotoToSpecialGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> savePhotoToSpecialGallery(
      String kresCode, String kresAdi, Photo myPhoto) {
    // TODO: implement savePhotoToSpecialGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> addAnnouncement(
      String kresCode, String kresAdi, Map<String, dynamic> map) {
    // TODO: implement addAnnouncement
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) {
    // TODO: implement getAnnouncements
    throw UnimplementedError();
  }

  @override
  Future<bool> updateUser(MyUser user) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteUser(MyUser user) async {
    await _auth.currentUser?.delete();
    return true;
  }

  @override
  Future<String> queryKresList(String kresCode) async {
    // TODO: implement getKresList
    throw UnimplementedError();
  }

  @override
  Future<bool> queryOgrID(String kresCode, String kresAdi, String ogrID) {
    // TODO: implement queryOgrID
    throw UnimplementedError();
  }

  @override
  Future<bool> sendNotificationToParent(String parentToken, String message) {
    // TODO: implement sendNotificationToParent
    throw UnimplementedError();
  }
}
