import 'dart:io';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();

  Future<MyUser?> signingWithEmailAndPassword(String email, String sifre);

  Future<MyUser?> createUserEmailAndPassword(String email, String sifre);

  Future<bool> signOut();
  Future<bool> updateUser(MyUser user);
  Future<bool> deleteUser(MyUser user);
  Future<bool> updateTeacherAuthorisation(String kresCode, String kresAdi,String teacherUserID);
  Future<String> queryKresList(String kresCode);

  Future<bool> queryOgrID(String kresCode, String kresAdi, String ogrID);
  Future<String> takeNewOgrID(String kresCode, String kresAdi);
  Future<bool> saveStudent(String kresCode, String kresAdi, Student student);
  Future<bool> deleteStudent(String kresCode, String kresAdi, Student student);
  Stream<List<Student>> getStudents(String kresCode, String kresAdi);
  Future<List<Student>> getStudentFuture(String kresCode, String kresAdi);
  Future<String> uploadOgrProfilePhoto(String kresCode, String kresAdi,
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya);
  Future<bool> deleteTeacher(String kresCode, String kresAdi, Teacher teacher);
  Stream<List<Teacher>> getTeachers(String kresCode, String kresAdi);
  Future<bool> addCriteria(String kresCode, String kresAdi, String criteria);
  Future<List<String>> getCriteria(String kresCode, String kresAdi);
  Future<bool> deleteCriteria(String kresCode, String kresAdi, String criteria);
  Future<String> uploadPhotoToGallery(String kresCode, String kresAdi,
      String ogrID, String ogrAdi, String fileType, File yuklenecekDosya);
  Future<bool> deletePhoto(
      String kresCode, String kresAdi, String ogrID, String fotoUrl);
  Future<bool> saveRatings(String kresCode, String kresAdi, String ogrID,
      Map<String, dynamic> ratings, bool showPhotoMainPage);
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID);
  Future<bool> savePhotoToMainGallery(
      String kresCode, String kresAdi, Photo myPhoto);
  Future<bool> savePhotoToSpecialGallery(
      String kresCode, String kresAdi, Photo myPhoto);
  Future<List<Photo>> getPhotoToMainGallery(String kresCode, String kresAdi);
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID);
  Future<bool> addAnnouncement(
      String kresCode, String kresAdi, Map<String, dynamic> map);
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi);
  Future<bool> sendNotificationToParent(String parentToken, String message);
  Future<bool> sendNotificationToYonetici(
      MyUser senderUser, String yoneticiToken);
  Future<String> getYoneticiToken(String kresCode, String kresAdi);
}
