import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser users);
  Future<MyUser> readUser(String userId);
  Future<bool> updateUser(MyUser user);
  Future<String> queryKresList(String kresCode);
  Future<bool> queryOgrID(String kresCode, String kresAdi, String ogrID);
  Future<bool> saveStudent(String kresCode, String kresAdi, Student student);
  Future<bool> deleteStudent(String kresCode, String kresAdi, Student student);
  Stream<List<Student>> getStudents(String kresCode, String kresAdi);
  Future<List<Student>> getStudentsFuture(String kresCode, String kresAdi);
  Future<Student> getStudent(String kresCode, String kresAdi, String ogrNo);

  Future<bool> deleteTeacher(String kresCode, String kresAdi, Teacher teacher);
  Stream<List<Teacher>> getTeachers(String kresCode, String kresAdi);
  Future<bool> addCriteria(String kresCode, String kresAdi, String criteria);
  Future<List<String>> getCriteria(String kresCode, String kresAdi);
  Future<bool> deleteCriteria(String kresCode, String kresAdi, String criteria);
  Future<bool> uploadPhotoToGallery(
      String kresCode, String kresAdi, String ogrID, String fotoUrl);
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
}
