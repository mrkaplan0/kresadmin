import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:kresadmin/models/user.dart';
import 'base/database_base.dart';

class FirestoreDBService implements DBBase {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser users) async {
    await _firestore
        .collection("Users")
        .doc(users.userID)
        .set(users.toMap())
        .then((value) => print("User Kaydedildi."))
        .catchError((error) => print("Kullanıcı kayıt hatası: $error"));

    DocumentSnapshot _okunanUser =
        await _firestore.doc('Users/${users.userID}').get();

    Map<String, dynamic> map = _okunanUser.data() as Map<String, dynamic>;
    MyUser _okunanUserNesnesi = MyUser.fromMap(map);

    print("Okunan user nesnesi" + _okunanUserNesnesi.toString());

    return true;
  }

  @override
  Future<MyUser> readUser(String userId) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection('Users').doc(userId).get();
    Map<String, dynamic> map = _okunanUser.data() as Map<String, dynamic>;
    MyUser _okunanUserNesnesi = MyUser.fromMap(map);

    print("Okunan user nesnesi" + map.toString());
    return _okunanUserNesnesi;
  }

  checkOgrIDisUseable(Student student) async {
    QuerySnapshot stuIsSaved = await _firestore
        .collection("Student")
        .where('ogrID', isEqualTo: student.ogrID)
        .get();

    if (stuIsSaved.docs.length > 0)
      return true;
    else
      return false;
  }

  @override
  Future<bool> saveStudent(Student student) async {
    await _firestore
        .collection("Student")
        .doc(student.ogrID)
        .set(student.toMap(), SetOptions(merge: true))
        .then((value) => print("Öğrenci Kaydedildi."))
        .catchError((error) => print("Öğrenci kayıt hatası: $error"));
    return true;
  }

  @override
  Future<bool> deleteStudent(Student student) async {
    await _firestore
        .collection("Student")
        .doc(student.ogrID)
        .delete()
        .then((value) => print("Öğrenci silindi."))
        .catchError((error) => print("Öğrenci silme hatası: $error"));
    await _firestore
        .collection("Veli")
        .doc(student.ogrID)
        .delete()
        .then((value) => print("veli silindi."))
        .catchError((error) => print("Öğrenci silme hatası: $error"));

    return true;
  }

  @override
  Future<Student> getStudent(String ogrNo) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('Student').doc(ogrNo).get();

    Student student =
        Student.fromMap(docSnapshot.data()! as Map<String, dynamic>);

    print(student);

    return student;
  }

  @override
  Stream<List<Student>> getStudents() {
    var snapShot = _firestore.collection('Student').snapshots();
    Stream<List<Student>> stuList = snapShot.map((ogrList) => ogrList.docs
        .map((student) => Student.fromMap(student.data()))
        .toList());
    return stuList;
  }

  @override
  Future<List<Student>> getStudentsFuture() async {
    QuerySnapshot querySnapshot = await _firestore.collection('Student').get();
    List<Student> list = [];

    for (DocumentSnapshot tekOgr in querySnapshot.docs) {
      print(tekOgr.data()! as Map<String, dynamic>);
      Student eklenecekStu =
          Student.fromMap(tekOgr.data()! as Map<String, dynamic>);
      list.add(eklenecekStu);
    }

    return list;
  }

  updateOgrProfilePhoto(String ogrID, String url) async {
    if (ogrID.length < 7)
      await _firestore
          .collection("Student")
          .doc(ogrID)
          .update({'fotoUrl': url});
    else
      //teacher ID, min 5 haneli olacak şekilde planladım.
      await _firestore
          .collection("Teacher")
          .doc(ogrID)
          .update({'fotoUrl': url});
  }

  @override
  Future<bool> saveTeacher(Teacher teacher) async {
    await _firestore
        .collection("Teacher")
        .doc(teacher.teacherID)
        .set(teacher.toMap(), SetOptions(merge: true))
        .then((value) => print("örtmen Kaydedildi."))
        .catchError((error) => print("örtmen kayıt hatası: $error"));
    return true;
  }

  @override
  Future<bool> deleteTeacher(Teacher teacher) async {
    await _firestore.collection("Teacher").doc(teacher.teacherID).delete();
    return true;
  }

  @override
  Stream<List<Teacher>> getTeachers() {
    var snapShot = _firestore.collection('Teacher').snapshots();

    return snapShot.map((ogrList) => ogrList.docs
        .map((teacher) => Teacher.fromMap(teacher.data()))
        .toList());
  }

  @override
  Future<bool> ogrNoControl(String ogrNo) async {
    if (ogrNo.length < 8) {
      QuerySnapshot stuIsSaved = await _firestore
          .collection("Student")
          .where('ogrID', isEqualTo: ogrNo)
          .get();

      if (stuIsSaved.docs.length > 0)
        return true;
      else
        return false;
    } else {
      QuerySnapshot stuIsSaved = await _firestore
          .collection("Teacher")
          .where('teacherID', isEqualTo: ogrNo)
          .get();
      print('teacher kontrol');
      if (stuIsSaved.docs.length > 0)
        return true;
      else
        return false;
    }
  }

  @override
  Future<bool> addCriteria(String criteria) async {
    await _firestore
        .collection("Criteria")
        .doc("Criteria")
        .set({criteria: criteria}, SetOptions(merge: true))
        .then((value) => print("kriter Kaydedildi."))
        .catchError((error) => print("kriter kayıt hatası: $error"));
    return true;
  }

  @override
  Future<bool> deleteCriteria(String criteria) async {
    await _firestore
        .collection("Criteria")
        .doc("Criteria")
        .set({criteria: FieldValue.delete()}, SetOptions(merge: true))
        .then((value) => print("kriter silindi."))
        .catchError((error) => print("kriter silme hatası: $error"));
    return true;
  }

  @override
  Future<List<String>> getCriteria() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("Criteria").doc("Criteria").get();

    List<String> kriterList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;
    map.values.forEach((element) {
      kriterList.add(element.toString());
    });
    return kriterList;
  }

  @override
  Future<bool> uploadPhotoToGallery(String ogrID, String fotoUrl) async {
    await _firestore
        .collection("Student")
        .doc(ogrID)
        .collection("Gallery")
        .doc(ogrID)
        .set({fotoUrl.substring(fotoUrl.indexOf('token=')): fotoUrl},
            SetOptions(merge: true));
    return true;
  }

  @override
  Future<bool> deletePhoto(String ogrID, String fotoUrl) async {
    await _firestore
        .collection("Student")
        .doc(ogrID)
        .collection("Gallery")
        .doc(ogrID)
        .update({
      fotoUrl.substring(fotoUrl.indexOf('token=')): FieldValue.delete()
    }).then((value) => print("Silindi."));
    return true;
  }

  @override
  Future<bool> saveRatings(String ogrID, Map<String, dynamic> ratings,
      bool showPhotoMainPage) async {
    await _firestore
        .collection("Student")
        .doc(ogrID)
        .collection("Ratings")
        .doc(ratings['Son Değerlendirme'].toString())
        .set(ratings, SetOptions(merge: true));
    if (showPhotoMainPage == true && ratings['Fotoğraflar'] != null) {
      for (int i = 0; i < ratings['Fotoğraflar'].length; i++)
        await _firestore.collection('Main').doc('Gallery').set(
            {Timestamp.now().toString(): ratings['Fotoğraflar'][i]},
            SetOptions(merge: true));
    }
    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getRatings(String ogrID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Student')
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
  Future<bool> savePhotoToMainGallery(Photo myPhoto) async {
    await _firestore
        .collection('Main')
        .doc('Gallery')
        .set({myPhoto.time: myPhoto.toMap()}, SetOptions(merge: true));

    if (myPhoto.ogrID != null) {
      await _firestore
          .collection("Student")
          .doc(myPhoto.ogrID)
          .collection("Gallery")
          .doc(myPhoto.ogrID)
          .set({myPhoto.time: myPhoto.toMap()}, SetOptions(merge: true));
    }
    return true;
  }

  @override
  Future<List<Photo>> getPhotoToMainGallery() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('Main').doc('Gallery').get();

    List<Photo> photoList = [];
    Map<String, dynamic> map = documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in map.values) {
      photoList.add(Photo.fromMap(map));
    }
    print(photoList);
    return photoList;
  }

  @override
  Future<List<Photo>> getPhotoToSpecialGallery(String ogrID) async {
    DocumentSnapshot documentSnapshot = await _firestore
        .collection("Student")
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
  Future<bool> savePhotoToSpecialGallery(Photo myPhoto) async {
    await _firestore
        .collection("Student")
        .doc(myPhoto.ogrID)
        .collection("Gallery")
        .doc(myPhoto.ogrID)
        .set({myPhoto.time: myPhoto.toMap()}, SetOptions(merge: true));

    return true;
  }

  @override
  Future<bool> addAnnouncement(Map<String, dynamic> map) async {
    await _firestore
        .collection("Announcement")
        .doc("Announcement")
        .set({map['Duyuru Başlığı']: map}, SetOptions(merge: true));

    return true;
  }

  @override
  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection("Announcement").doc("Announcement").get();
    List<Map<String, dynamic>> duyuruList = [];
    Map<String, dynamic> maps =
        documentSnapshot.data()! as Map<String, dynamic>;

    for (Map<String, dynamic> map in maps.values) {
      duyuruList.add(map);
    }
    return duyuruList;
  }
}
