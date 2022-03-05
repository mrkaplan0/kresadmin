import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/services/base/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  FirebaseAuth _auth = FirebaseAuth.instance;

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
  Future<MyUser?> signingWithAnonymously() async {
    try {
      UserCredential sonuc = await _auth.signInAnonymously();

      return _usersFromFirebase(sonuc.user!);
    } catch (e) {
      debugPrint("Hata SignAnonymously $e");
      return null;
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
  Future<String> uploadOgrProfilePhoto(
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya) {
    // TODO: implement uploadOgrProfilePhoto
    throw UnimplementedError();
  }

  @override
  Future<bool> saveStudent(Student student) {
    // TODO: implement saveStudent
    throw UnimplementedError();
  }

  @override
  Stream<List<Student>> getStudents() {
    // TODO: implement getStudents
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteStudent(Student student) {
    // TODO: implement deleteStudent
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTeacher(Teacher teacher) {
    // TODO: implement deleteTeacher
    throw UnimplementedError();
  }

  @override
  Stream<List<Teacher>> getTeachers() {
    // TODO: implement getTeachers
    throw UnimplementedError();
  }

  @override
  Future<bool> saveTeacher(Teacher teacher) {
    // TODO: implement saveTeacher
    throw UnimplementedError();
  }

  @override
  Future<bool> ogrNoControl(String ogrNo) {
    // TODO: implement ogrNoControl
    throw UnimplementedError();
  }

  @override
  Future<List<Student>> getStudentFuture() async {
    // TODO: implement getStudentFuture
    throw UnimplementedError();
  }

  @override
  Future<bool> addCriteria(String criteria) {
    // TODO: implement addCriteria
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCriteria(String criteria) {
    // TODO: implement deleteCriteria
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getCriteria() {
    // TODO: implement getCriteria
    throw UnimplementedError();
  }

  @override
  Future<bool> deletePhoto(String ogrID, String fotoUrl) {
    // TODO: implement deletePhoto
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(String ogrID) {
    // TODO: implement getRatings
    throw UnimplementedError();
  }

  @override
  Future<bool> saveRatings(
      String ogrID, Map<String, dynamic> ratings, bool showPhotoMainPage) {
    // TODO: implement saveRatings
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPhotoToGallery(
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya) {
    // TODO: implement uploadPhotoToGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery() {
    // TODO: implement getPhotoToMainGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> savePhotoToMainGallery(Photo myPhoto) {
    // TODO: implement savePhotoToMainGallery
    throw UnimplementedError();
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID) {
    // TODO: implement getPhotoToSpecialGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto) {
    // TODO: implement savePhotoToSpecialGallery
    throw UnimplementedError();
  }

  @override
  Future<bool> addAnnouncement(Map<String, dynamic> map) {
    // TODO: implement addAnnouncement
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements() {
    // TODO: implement getAnnouncements
    throw UnimplementedError();
  }
}
