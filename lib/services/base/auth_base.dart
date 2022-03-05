import 'dart:io';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();

  Future<MyUser?> signingWithAnonymously();

  Future<MyUser?> signingWithEmailAndPassword(String email, String sifre);

  Future<MyUser?> createUserEmailAndPassword(String email, String sifre);

  Future<bool> signOut();
  Future<bool> ogrNoControl(String ogrNo);

  Future<bool> saveStudent(Student student);
  Future<bool> deleteStudent(Student student);
  Stream<List<Student>> getStudents();
  Future<List<Student>> getStudentFuture();
  Future<String> uploadOgrProfilePhoto(
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya);

  Future<bool> saveTeacher(Teacher teacher);
  Future<bool> deleteTeacher(Teacher teacher);
  Stream<List<Teacher>> getTeachers();
  Future<bool> addCriteria(String criteria);
  Future<List<String>> getCriteria();
  Future<bool> deleteCriteria(String criteria);
  Future<String> uploadPhotoToGallery(
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya);
  Future<bool> deletePhoto(String ogrID, String fotoUrl);
  Future<bool> saveRatings(
      String ogrID, Map<String, dynamic> ratings, bool showPhotoMainPage);
  Future<List<Map<String, dynamic>>> getRatings(String ogrID);
  Future<bool> savePhotoToMainGallery(Photo myPhoto);
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto);
  Future<List<Photo>> getPhotoToMainGallery();
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID);
  Future<bool> addAnnouncement(Map<String, dynamic> map);
  Future<List<Map<String, dynamic>>> getAnnouncements();
}
