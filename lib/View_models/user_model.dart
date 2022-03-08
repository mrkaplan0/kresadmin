import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kresadmin/locator.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/repository/user_repository.dart';
import 'package:kresadmin/services/base/auth_base.dart';

enum ViewState { idle, busy }

class UserModel with ChangeNotifier implements AuthBase {
  final UserRepository _userRepository = locator<UserRepository>();
  MyUser? _users;

  String? emailHataMesaj;
  String? sifreHataMesaj;

  // ignore: unnecessary_getters_setters
  MyUser? get users => _users;
  // ignore: unnecessary_getters_setters
  set users(MyUser? value) {
    _users = value;
  }

  UserModel() {
    currentUser();
  }
  var _state = ViewState.idle;
  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      state = ViewState.busy;
      _users = await _userRepository.currentUser();
      if (_users != null)
        return _users;
      else
        return null;
    } catch (e) {
      return null;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.signOut();

      _users = null;
      return sonuc;
    } catch (e) {
      debugPrint("User Model signout HATAAAA :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> updateUser(MyUser user) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.updateUser(user);

      return sonuc;
    } catch (e) {
      debugPrint("User Model update user error :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> signingWithEmailAndPassword(
      String email, String sifre) async {
    try {
      if (emailsifreKontrol(email, sifre)) {
        state = ViewState.busy;
        _users =
            await _userRepository.signingWithEmailAndPassword(email, sifre);

        return _users;
      } else
        return null;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<MyUser?> createUserEmailAndPassword(String email, String sifre) async {
    try {
      if (emailsifreKontrol(email, sifre)) {
        state = ViewState.busy;
        _users =
            (await _userRepository.createUserEmailAndPassword(email, sifre))!;
        return _users;
      } else
        return null;
    } finally {
      state = ViewState.idle;
    }
  }

  bool emailsifreKontrol(String email, String sifre) {
    var sonuc = true;

    if (!email.contains('@')) {
      emailHataMesaj = 'Geçerli bir email adresi girin.';
      sonuc = false;
    } else
      emailHataMesaj = null;
    return sonuc;
  }

  @override
  Future<bool> deleteUser(MyUser user) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deleteUser(user);

      return sonuc;
    } catch (e) {
      debugPrint("User Model delete hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<String> queryKresList(String kresCode) async {
    try {
      state = ViewState.busy;
      var sonuc = await _userRepository.queryKresList(kresCode);

      return sonuc;
    } catch (e) {
      debugPrint("User Model query kres hata :" + e.toString());
      return "HATA:" + e.toString();
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> saveStudent(Student student) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.saveStudent(student);

      return sonuc;
    } catch (e) {
      debugPrint("User Model saveStudent hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> deleteStudent(Student student) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deleteStudent(student);

      return sonuc;
    } catch (e) {
      debugPrint("User Model delStudent hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<String> uploadOgrProfilePhoto(String ogrID, String ogrAdi,
      String fileType, File yuklenecekDosya) async {
    try {
      state = ViewState.busy;
      return await _userRepository.uploadOgrProfilePhoto(
          ogrID, ogrAdi, fileType, yuklenecekDosya);
    } catch (e) {
      debugPrint("User Model profil photo hata :" + e.toString());
      return '';
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Stream<List<Student>> getStudents() {
    try {
      var sonuc = _userRepository.getStudents();

      return sonuc;
    } catch (e) {
      debugPrint("User Model getStudent hata :" + e.toString());
      return Stream.empty();
    }
  }

  @override
  Future<bool> saveTeacher(Teacher teacher) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.saveTeacher(teacher);

      return sonuc;
    } catch (e) {
      debugPrint("User Model saveteacher hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> deleteTeacher(Teacher teacher) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deleteTeacher(teacher);

      return sonuc;
    } catch (e) {
      debugPrint("User Model delStudent hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Stream<List<Teacher>> getTeachers() {
    try {
      var sonuc = _userRepository.getTeachers();

      return sonuc;
    } catch (e) {
      debugPrint("User Model getteach hata :" + e.toString());
      return Stream.empty();
    }
  }

  @override
  Future<bool> ogrNoControl(String ogrNo) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.ogrNoControl(ogrNo);

      return sonuc;
    } catch (e) {
      debugPrint("User Model noContorl hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Student>> getStudentFuture() async {
    try {
      List<Student> sonuc = await _userRepository.getStudentFuture();

      return sonuc;
    } finally {}
  }

  @override
  Future<bool> addCriteria(String criteria) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.addCriteria(criteria);

      return sonuc;
    } catch (e) {
      debugPrint("User Model criter hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> deleteCriteria(String criteria) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deleteCriteria(criteria);

      return sonuc;
    } catch (e) {
      debugPrint("User Model criter sil hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<String>> getCriteria() async {
    try {
      var sonuc = await _userRepository.getCriteria();

      return sonuc;
    } catch (e) {
      debugPrint("User Model criter sil hata :" + e.toString());
      return List.empty();
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> deletePhoto(String ogrID, String fotoUrl) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.deletePhoto(ogrID, fotoUrl);

      return sonuc;
    } catch (e) {
      debugPrint("User Model foto sil hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<String> uploadPhotoToGallery(String ogrID, String ogrAdi,
      String fileType, File yuklenecekDosya) async {
    try {
      state = ViewState.busy;
      String sonuc = await _userRepository.uploadPhotoToGallery(
          ogrID, ogrAdi, fileType, yuklenecekDosya);

      return sonuc;
    } catch (e) {
      debugPrint("User Model foto upload hata :" + e.toString());
      return 'false';
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(String ogrID) async {
    try {
      return await _userRepository.getRatings(ogrID);
    } catch (e) {
      debugPrint("User Model criter getir hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<bool> saveRatings(String ogrID, Map<String, dynamic> ratings,
      bool showPhotoMainPage) async {
    try {
      state = ViewState.busy;
      bool sonuc =
          await _userRepository.saveRatings(ogrID, ratings, showPhotoMainPage);

      return sonuc;
    } catch (e) {
      debugPrint("User Model save ratings hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery() async {
    try {
      var sonuc = await _userRepository.getPhotoToMainGallery();

      return sonuc;
    } catch (e) {
      debugPrint("User Model savephoto hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<bool> savePhotoToMainGallery(Photo myPhoto) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.savePhotoToMainGallery(myPhoto);

      return sonuc;
    } catch (e) {
      debugPrint("User Model savephoto hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID) async {
    try {
      var sonuc = await _userRepository.getPhotoToSpecialGallery(ogrID);

      return sonuc;
    } catch (e) {
      debugPrint("User Model getphoto hata :" + e.toString());
      return List.empty();
    }
  }

  @override
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto) async {
    try {
      state = ViewState.busy;
      bool sonuc = await _userRepository.savePhotoToSpecialGallery(myPhoto);

      return sonuc;
    } catch (e) {
      debugPrint("User Model savephoto hata :" + e.toString());
      return false;
    } finally {
      state = ViewState.idle;
    }
  }

  @override
  Future<bool> addAnnouncement(Map<String, dynamic> map) async {
    try {
      var sonuc = await _userRepository.addAnnouncement(map);

      return sonuc;
    } catch (e) {
      debugPrint("User Model savephoto hata :" + e.toString());
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      var sonuc = await _userRepository.getAnnouncements();

      return sonuc;
    } catch (e) {
      debugPrint("User Model get announcment hata :" + e.toString());
      return List.empty();
    } finally {
      state = ViewState.idle;
    }
  }
}
