// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:kresadmin/models/events.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'package:table_calendar/table_calendar.dart';
import 'base/database_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? token;

  @override
  Future<bool> saveUser(MyUser users) async {
    token = await _messaging.getToken();
    users.token = token;
    await _firestore
        .collection("Users")
        .doc(users.userID)
        .set(users.toMap())
        .then((value) => debugPrint("User Kaydedildi."))
        .catchError((error) => debugPrint("Kullanıcı kayıt hatası: $error"));

    return true;
  }

  @override
  Future<MyUser> readUser(String userId) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection('Users').doc(userId).get();
    Map<String, dynamic> map = _okunanUser.data() as Map<String, dynamic>;
    MyUser _okunanUserNesnesi = MyUser.fromMap(map);

    debugPrint("Okunan user nesnesi$map");
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUser(MyUser user) async {
    bool updateResult = true;
    try {
      if (user.position == "Admin") {
        int kresCode = await createKresCode();
        kresCode != 0
            ? user.kresCode = kresCode.toString()
            : updateResult = false;
        bool r = await createAdminAndKres(user);
        r == false ? updateResult = false : null;
      } else if (user.position == "Teacher") {
        Teacher t = Teacher(
            teacherID: user.userID!,
            adiSoyadi: user.username!,
            telefonNo: user.phone,
            position: user.position,
            kresAdi: user.kresAdi,
            kresCode: user.kresCode,
            token: token,
            authorisation: false);
        await _firestore
            .collection("Kresler")
            .doc('${user.kresCode!}_${user.kresAdi!}')
            .collection(user.kresAdi!)
            .doc(user.kresAdi)
            .collection("Teachers")
            .doc(t.teacherID)
            .set(t.toMap(), SetOptions(merge: true));
      }
      await _firestore
          .collection("Users")
          .doc(user.userID)
          .set(user.toMap(), SetOptions(merge: true));
      return updateResult;
    } catch (e) {
      return false;
    }
  }

  Future<int> createKresCode() async {
    int kresCode = 0;
    DocumentSnapshot kc =
        await _firestore.collection("KresCode").doc("KresCode").get();
    Map<String, dynamic> map = kc.data()! as Map<String, dynamic>;
    kresCode = ++map["KresCode"];
    await _firestore
        .collection("KresCode")
        .doc("KresCode")
        .set({"KresCode": kresCode});
    return kresCode;
  }

  Future<bool> createAdminAndKres(MyUser user) async {
    String? t = await _messaging.getToken();
    await _firestore
        .collection("KreslerChecking")
        .doc('${user.kresCode!}_${user.kresAdi!}')
        .set({
      "kresCode": user.kresCode,
      "kresAdi": user.kresAdi,
      "yoneticiToken": t
    }, SetOptions(merge: true));
    await _firestore
        .collection("Kresler")
        .doc('${user.kresCode!}_${user.kresAdi!}')
        .collection(user.kresAdi!)
        .doc(user.kresAdi)
        .set({
      "kresCode": user.kresCode,
      "kresAdi": user.kresAdi,
      "yoneticiToken": t
    }, SetOptions(merge: true));
    await _firestore
        .collection("Kresler")
        .doc('${user.kresCode!}_${user.kresAdi!}')
        .collection(user.kresAdi!)
        .doc(user.kresAdi!)
        .collection("UploadCounts")
        .doc("UploadCounts")
        .set({
      "Counts": 5,
    }, SetOptions(merge: true));

    await _firestore.collection("Admins").doc(user.kresCode).set(user.toMap());

    return true;
  }

  checkOgrIDisUseable(String kresCode, String kresAdi, Student student) async {
    QuerySnapshot stuIsSaved = await _firestore
        .collection("Student")
        .where('ogrID', isEqualTo: student.ogrID)
        .get();

    if (stuIsSaved.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<String> queryKresList(String kresCode) async {
    QuerySnapshot checkKresCode = await _firestore
        .collection("KreslerChecking")
        .where('kresCode', isEqualTo: kresCode)
        .get();

    if (checkKresCode.docs.isNotEmpty) {
      debugPrint(checkKresCode.docs.first.data().toString());
      Map<String, dynamic> map =
          checkKresCode.docs.first.data() as Map<String, dynamic>;
      return map['kresAdi'].toString();
    } else {
      return '';
    }
  }

  @override
  Future<bool> queryOgrID(String kresCode, String kresAdi, String ogrID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("KreslerChecking")
        .doc('${kresCode}_$kresAdi')
        .collection("Students")
        .get();
    List<int> list = [];

    for (DocumentSnapshot ogrID in querySnapshot.docs) {
      Map<String, dynamic> map = ogrID.data()! as Map<String, dynamic>;
      list.add(int.parse(map['ogrID']));
    }
    var r = list.contains(int.parse(ogrID));
    return r;
  }

  @override
  Future<String> getYoneticiToken(String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("KreslerChecking")
        .doc('${kresCode}_$kresAdi')
        .get();

    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;
    String tkn = map['yoneticiToken'];
    debugPrint("db yön tokn : $tkn");
    return tkn;
  }

  @override
  Future<String> takeNewOgrID(String kresCode, String kresAdi) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("KreslerChecking")
        .doc('${kresCode}_$kresAdi')
        .collection("Students")
        .get();
    List<int> list = [];

    for (DocumentSnapshot ogrID in querySnapshot.docs) {
      Map<String, dynamic> map = ogrID.data()! as Map<String, dynamic>;
      list.add(int.parse(map['ogrID']));
    }
    int r = 0;
    if (list.isNotEmpty) {
      list.sort();
      r = list.last;
    }
    return "${r + 1}";
  }

  @override
  Future<bool> saveStudent(
      String kresCode, String kresAdi, Student student) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(student.ogrID)
        .set(student.toMap(), SetOptions(merge: true))
        .then((value) => debugPrint("Öğrenci Kaydedildi."))
        .catchError((error) => debugPrint("Öğrenci kayıt hatası: $error"));

    await _firestore
        .collection("KreslerChecking")
        .doc('${kresCode}_$kresAdi')
        .collection("Students")
        .doc(student.ogrID)
        .set({
      "ogrID": student.ogrID,
    }, SetOptions(merge: true));
    return true;
  }

  @override
  Future<bool> deleteStudent(
      String kresCode, String kresAdi, Student student) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(student.ogrID)
        .delete()
        .then((value) => debugPrint("Öğrenci silindi."))
        .catchError((error) => debugPrint("Öğrenci silme hatası: $error"));
    await _firestore
        .collection("KreslerChecking")
        .doc('${kresCode}_$kresAdi')
        .collection("Students")
        .doc(student.ogrID)
        .delete()
        .then((value) => debugPrint("Öğrenci silindi."))
        .catchError((error) => debugPrint("Öğrenci silme hatası: $error"));
    return true;
  }

  @override
  Future<Student> getStudent(
      String kresCode, String kresAdi, String ogrNo) async {
    DocumentSnapshot docSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .doc(ogrNo)
        .get();

    Student student =
        Student.fromMap(docSnapshot.data()! as Map<String, dynamic>);

    debugPrint(student.toString());

    return student;
  }

  @override
  Stream<List<Student>> getStudents(String kresCode, String kresAdi) {
    var snapShot = _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .snapshots();
    Stream<List<Student>> stuList = snapShot.map((ogrList) => ogrList.docs
        .map((student) => Student.fromMap(student.data()))
        .toList());
    return stuList;
  }

  @override
  Future<List<Student>> getStudentsFuture(
      String kresCode, String kresAdi) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .get();
    List<Student> list = [];

    for (DocumentSnapshot tekOgr in querySnapshot.docs) {
      debugPrint((tekOgr.data()! as Map<String, dynamic>).toString());
      Student eklenecekStu =
          Student.fromMap(tekOgr.data()! as Map<String, dynamic>);
      list.add(eklenecekStu);
    }

    return list;
  }

  updateOgrProfilePhoto(
      String kresCode, String kresAdi, String ogrID, String url) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .doc(ogrID)
        .update({'fotoUrl': url});
  }

  updateTeacherProfilePhoto(
      String kresCode, String kresAdi, String ogrID, String url) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Teachers')
        .doc(ogrID)
        .update({'fotoUrl': url});
  }

  @override
  Future<bool> updateTeacherAuthorisation(
      String kresCode, String kresAdi, String teacherUserID) async {
    await _firestore
        .collection("Users")
        .doc(teacherUserID)
        .update({'isAdmin': true});

    return true;
  }

  @override
  Future<bool> deleteTeacher(
      String kresCode, String kresAdi, Teacher teacher) async {
    await _firestore
        .collection("Users")
        .doc(teacher.teacherID)
        .update({'isAdmin': false});

    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Teachers")
        .doc(teacher.teacherID)
        .delete();
    return true;
  }

  @override
  Stream<List<Teacher>> getTeachers(String kresCode, String kresAdi) {
    var snapShot = _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Teachers')
        .snapshots();

    return snapShot.map((ogrList) => ogrList.docs
        .map((teacher) => Teacher.fromMap(teacher.data()))
        .toList());
  }

  @override
  Future<bool> addCriteria(
      String kresCode, String kresAdi, String criteria) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Criteria")
        .doc("Criteria")
        .set({criteria: criteria}, SetOptions(merge: true))
        .then((value) => debugPrint("kriter Kaydedildi."))
        .catchError((error) => debugPrint("kriter kayıt hatası: $error"));
    return true;
  }

  @override
  Future<bool> deleteCriteria(
      String kresCode, String kresAdi, String criteria) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Criteria")
        .doc("Criteria")
        .set({criteria: FieldValue.delete()}, SetOptions(merge: true))
        .then((value) => debugPrint("kriter silindi."))
        .catchError((error) => debugPrint("kriter silme hatası: $error"));
    return true;
  }

  @override
  Future<List<String>> getCriteria(String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Criteria")
        .doc("Criteria")
        .get();

    List<String> kriterList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;
    for (var element in map.values) {
      kriterList.add(element.toString());
    }
    return kriterList;
  }

  @override
  Future<bool> uploadPhotoToGallery(
      String kresCode, String kresAdi, String ogrID, String fotoUrl) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(ogrID)
        .collection("Gallery")
        .doc(ogrID)
        .set({fotoUrl.substring(fotoUrl.indexOf('token=')): fotoUrl},
            SetOptions(merge: true));
    return true;
  }

  @override
  Future<bool> deletePhoto(
      String kresCode, String kresAdi, String? ogrID, Photo photo) async {
    if (ogrID != null) {
      await _firestore
          .collection("Kresler")
          .doc('${kresCode}_$kresAdi')
          .collection(kresAdi)
          .doc(kresAdi)
          .collection("Students")
          .doc(photo.ogrID)
          .collection("Gallery")
          .doc(photo.ogrID)
          .set({photo.time: FieldValue.delete()}, SetOptions(merge: true)).then(
              (value) => debugPrint(" Stu foto Silindi."));
      return true;
    } else {
      await _firestore
          .collection("Kresler")
          .doc('${kresCode}_$kresAdi')
          .collection(kresAdi)
          .doc(kresAdi)
          .collection('Main')
          .doc('Gallery')
          .set({photo.time: FieldValue.delete()}, SetOptions(merge: true)).then(
              (value) => debugPrint(" Main Galeri foto Silindi."));
      return true;
    }
  }

  @override
  Future<bool> saveRatings(String kresCode, String kresAdi, String ogrID,
      Map<String, dynamic> ratings, bool showPhotoMainPage) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(ogrID)
        .collection("Ratings")
        .doc(ratings['Değerlendirme Tarihi'].toString())
        .set(ratings, SetOptions(merge: true));
    if (showPhotoMainPage == true && ratings['Fotoğraflar'] != null) {
      for (int i = 0; i < ratings['Fotoğraflar'].length; i++) {
        await _firestore.collection('Main').doc('Gallery').set(
            {Timestamp.now().toString(): ratings['Fotoğraflar'][i]},
            SetOptions(merge: true));
      }
    }
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(
      String kresCode, String kresAdi, String ogrID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Students')
        .doc(ogrID)
        .collection("Ratings")
        .get();
    List<Map<String, dynamic>> list = [];

    for (DocumentSnapshot rating in querySnapshot.docs) {
      list.add(rating.data()! as Map<String, dynamic>);
    }

    return list;
  }

  @override
  Future<bool> savePhotoToMainGallery(
      String kresCode, String kresAdi, Photo myPhoto) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Main')
        .doc('Gallery')
        .set({myPhoto.time: myPhoto.toMap()}, SetOptions(merge: true));

    if (myPhoto.ogrID != null) {
      await savePhotoToSpecialGallery(kresCode, kresAdi, myPhoto);
    }
    await decreaseUploadCount(kresCode, kresAdi);
    return true;
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery(
      String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection('Main')
        .doc('Gallery')
        .get();

    List<Photo> photoList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in map.values) {
      photoList.add(Photo.fromMap(map));
    }
    debugPrint(photoList.toString());
    return photoList;
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(
      String kresCode, String kresAdi, String ogrID) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(ogrID)
        .collection('Gallery')
        .doc(ogrID)
        .get();

    List<Photo> photoList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in map.values) {
      photoList.add(Photo.fromMap(map));
    }

    return photoList;
  }

  @override
  Future<bool> savePhotoToSpecialGallery(
      String kresCode, String kresAdi, Photo myPhoto) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Students")
        .doc(myPhoto.ogrID)
        .collection("Gallery")
        .doc(myPhoto.ogrID)
        .set({myPhoto.time: myPhoto.toMap()}, SetOptions(merge: true));

    await decreaseUploadCount(kresCode, kresAdi);

    return true;
  }

  Future decreaseUploadCount(String kresCode, String kresAdi) async {
    DocumentSnapshot d = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("UploadCounts")
        .doc("UploadCounts")
        .get();

    Map<String, dynamic> map = d.data()! as Map<String, dynamic>;
    int newCount = map['Counts'] - 1;

    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("UploadCounts")
        .doc("UploadCounts")
        .update({'Counts': newCount});
  }

  @override
  Future<bool> addAnnouncement(
      String kresCode, String kresAdi, Map<String, dynamic> map) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Announcement")
        .doc("Announcement")
        .set({map['Duyuru Başlığı']: map}, SetOptions(merge: true));

    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements(
      String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Announcement")
        .doc("Announcement")
        .get();
    List<Map<String, dynamic>> duyuruList = [];
    Map<String, dynamic> maps =
        documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in maps.values) {
      duyuruList.add(map);
    }

    duyuruList.sort((a, b) {
      return DateTime.parse(b['Duyuru Tarihi'])
          .compareTo(DateTime.parse(a['Duyuru Tarihi']));
    });
    return duyuruList;
  }

  @override
  Future<int> getUploadCounts(String kresCode, String kresAdi) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("UploadCounts")
        .doc("UploadCounts")
        .get();
    Map<String, dynamic> maps =
        documentSnapshot.data()! as Map<String, dynamic>;
    int counts = maps['Counts'];
    return counts;
  }

  @override
  Future<void> updateUploadCounts(String kresCode, String kresAdi) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("UploadCounts")
        .doc("UploadCounts")
        .update({'Counts': 5});
  }

  @override
  Future<bool> addNewEvents(
      String kresCode, String kresAdi, Event newEvent) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Events")
        .doc(newEvent.eventsID)
        .set(newEvent.toMap(), SetOptions(merge: true));

    return true;
  }

  @override
  Future<bool> deleteEvent(
      String kresCode, String kresAdi, Event eventWillBeDeleted) async {
    await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Events")
        .doc(eventWillBeDeleted.eventsID)
        .delete();
    return true;
  }

  @override
  Future<Map<DateTime, List<Event>>> fetchEvents(
      String kresCode, String kresAdi) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("Kresler")
        .doc('${kresCode}_$kresAdi')
        .collection(kresAdi)
        .doc(kresAdi)
        .collection("Events")
        .get();
    List<Event> eventList = [];
    Map<DateTime, List<Event>> groupedEvents = {};

    for (DocumentSnapshot event in querySnapshot.docs) {
      Event e = Event.fromMap((event.data()! as Map<String, dynamic>));
      eventList.add(e);
    }
    for (Event event in eventList) {
      if (groupedEvents.containsKey(event.eventDate)) {
        groupedEvents[event.eventDate]!.add(event);
      } else {
        groupedEvents[event.eventDate] = [event];
      }
    }

    return groupedEvents;
  }
}
