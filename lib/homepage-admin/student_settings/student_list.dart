import 'dart:io';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_page_for_visitor.dart';

import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Öğrenci Listesi",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(
              height: kdefaultPadding,
            ),
            studentListWidget(context)
          ],
        ),
      ),
    );
  }

  Widget studentListWidget(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    return Expanded(
      child: StreamBuilder<List<Student>>(
        stream: _userModel.getStudents(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            List<Student> ogrList = sonuc.data!;

            if (ogrList.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: ogrList.length,
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
                                  child: ogrList[i].fotoUrl == null
                                      ? const Center(child: Icon(Icons.person))
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(40)),
                                          child: ExtendedImage.network(
                                            ogrList[i].fotoUrl!,
                                            fit: BoxFit.cover,
                                            cache: true,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            title: Text(ogrList[i].adiSoyadi),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Öğr. No: " + ogrList[i].ogrID),
                                const Divider(
                                  thickness: 2,
                                ),
                                Text("Sınıfı: " + ogrList[i].sinifi!),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.only(right: 5),
                              width: 110,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      _editPhotoWithDialog(ogrList[i]);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    color: Colors.red,
                                    onPressed: () async {
                                      _deletePersonelWithDialog(ogrList[i]);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StudentPage(ogrList[i]))),
                          ),
                        ));
                  });
            } else {
              return const Center(
                child: Text("Öğrenci listesi yok."),
              );
            }
          } else {
            return const Center(
              child: Text("Öğrenci listesi yok!"),
            );
          }
        },
      ),
    );
  }

  Future<void> _deletePersonelWithDialog(Student stu) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final UserModel _userModel =
            Provider.of<UserModel>(context, listen: false);
        return SimpleDialog(
          title: const Text('Personel Sil'),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(' Kişiyi silmek istediğinizden emin misiniz?'),
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      bool sonuc = await _userModel.deleteStudent(
                          _userModel.users!.kresCode!,
                          _userModel.users!.kresAdi!,
                          stu);

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
                  child: const Text("Sil"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                  child: const Text("İptal"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _editPhotoWithDialog(Student stu) async {
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

                      uploadProfilePhoto(photo, stu);
                    },
                    child: const Text("Foto Çek")),
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      // Pick an image
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);

                      uploadProfilePhoto(image, stu);
                    },
                    child: const Text("Galeriden Seç"))
              ],
            ),
          ],
        );
      },
    );
  }

  uploadProfilePhoto(XFile? photo, Student student) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    File file = File(photo!.path);
    var url = await _userModel.uploadOgrProfilePhoto(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        student.ogrID,
        student.adiSoyadi,
        "profil_foto",
        file);

    if (url != null) {
      student.fotoUrl = url;

      debugPrint(url);
    }
    setState(() {});
  }
}
