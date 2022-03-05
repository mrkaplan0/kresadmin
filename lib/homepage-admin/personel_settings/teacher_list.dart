import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:provider/provider.dart';

class TeacherListPage extends StatefulWidget {
  @override
  _TeacherListPageState createState() => _TeacherListPageState();
}

class _TeacherListPageState extends State<TeacherListPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Öğretmen Listesi",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              height: kdefaultPadding,
            ),
            teacherListWidget(context)
          ],
        ),
      ),
    );
  }

  Widget teacherListWidget(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    return Expanded(
      child: Container(
        child: StreamBuilder<List<Teacher>>(
          stream: _userModel.getTeachers(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              List<Teacher> teacherList = sonuc.data!;
              print(teacherList.toString());
              if (teacherList.length > 0) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: teacherList.length,
                    itemBuilder: (context, i) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            child: ListTile(
                              leading: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: primaryColor, width: 3),
                                        shape: BoxShape.circle,
                                        color: Colors.orangeAccent.shade100),
                                    height: 50,
                                    width: 50,
                                    child: teacherList[i].fotoUrl == null
                                        ? Center(child: Icon(Icons.person))
                                        : ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(40)),
                                            child: Image.network(
                                                teacherList[i].fotoUrl!,
                                                fit: BoxFit.cover),
                                          ),
                                  ),
                                ],
                              ),
                              title: Text(teacherList[i].adiSoyadi),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Öğr. No: " + teacherList[i].teacherID),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text("Sınıfı: " + teacherList[i].sinifi!),
                                ],
                              ),
                              trailing: Container(
                                padding: EdgeInsets.only(right: 5),
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.blueGrey,
                                      onPressed: () {
                                        _editPhotoWithDialog(teacherList[i]);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      onPressed: () async {
                                        _deletePersonelWithDialog(
                                            teacherList[i]);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return Center(
                  child: Text("Lütfen Ayarlara Gidip Masa Değeri Giriniz"),
                );
              }
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }

  Future<void> _deletePersonelWithDialog(Teacher teacher) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final UserModel _userModel =
            Provider.of<UserModel>(context, listen: false);
        return SimpleDialog(
          title: const Text('Personel Sil'),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(' Kişiyi silmek istediğinizden emin misiniz?'),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      bool sonuc = await _userModel.deleteTeacher(teacher);

                      if (sonuc == true) {
                        Navigator.of(context).pop();
                        setState(() {});

                        Get.snackbar('İşlem Tamam!', 'Silme Başarılı.',
                            snackPosition: SnackPosition.BOTTOM);
                      } else {
                        Get.snackbar('HATA',
                            'Kişiyi silerken hata oluştu,daha sonra tekrar deneyiniz.');
                      }
                    } catch (e) {
                      debugPrint('Personel silme hatası ' + e.toString());
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orangeAccent)),
                  child: Text("Sil"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  child: Text("İptal"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPhotoWithDialog(Teacher teacher) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Foto Ekle'),
          children: [
            ButtonBar(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      // Capture a photo
                      final XFile? photo =
                          await _picker.pickImage(source: ImageSource.camera);

                      uploadProfilePhoto(photo, teacher);
                    },
                    child: Text("Foto Çek")),
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      // Pick an image
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      uploadProfilePhoto(image, teacher);
                    },
                    child: Text("Galeriden Seç"))
              ],
            ),
          ],
        );
      },
    );
  }

  uploadProfilePhoto(XFile? photo, Teacher teacher) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    File file = File(photo!.path);
    var url = await _userModel.uploadOgrProfilePhoto(
        teacher.teacherID, teacher.adiSoyadi, "profil_foto", file);

    if (url != null) {
      teacher.fotoUrl = url;

      print(url);
    }
    setState(() {});
  }
}
