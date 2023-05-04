// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:kresadmin/models/teacher.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:provider/provider.dart';

class AddTeacherPhoto extends StatefulWidget {
  final Teacher teacher;

  const AddTeacherPhoto(this.teacher, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddTeacherPhotoState createState() => _AddTeacherPhotoState();
}

class _AddTeacherPhotoState extends State<AddTeacherPhoto> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: kdefaultPadding + 10),
              const Text("Öğretmen profil foto ekleyin"),
              const SizedBox(height: kdefaultPadding),
              photoWidget(context),
              const SizedBox(height: kdefaultPadding),
              ogrenciBilgileriWidget(context),
              const SizedBox(height: kdefaultPadding),
              const SizedBox(height: kdefaultPadding),
              SocialLoginButton(
                  btnText: 'Kaydet',
                  btnColor: Theme.of(context).primaryColor,
                  onPressed: () => saveTeacher(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget ogrenciBilgileriWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: primaryColor)),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Öğretmen Bilgileri",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: kdefaultPadding),
            Text("Öğretmen No       : ${widget.teacher.teacherID}"),
            Text("Adı Soyadı            : ${widget.teacher.adiSoyadi}"),
            Text("Telefon No            : ${widget.teacher.telefonNo}"),
            Text("Sınıfı                      : ${widget.teacher.sinifi}"),
          ],
        ),
      ),
    );
  }

  Widget photoWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => photoFrom(),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: primaryColor, width: 3),
                shape: BoxShape.circle,
                color: Colors.orangeAccent.shade100),
            height: 150,
            width: 150,
            child: showPhoto(),
          ),
          const Positioned(
            bottom: 7,
            right: 7,
            child: Icon(
              Icons.add_a_photo_rounded,
              color: primaryColor,
              size: 40,
            ),
          )
        ],
      ),
    );
  }

  photoFrom() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Foto Yükle?'),
          actions: [
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                  // Capture a photo
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.camera);

                  uploadProfilePhoto(photo);
                },
                child: const Text("Foto Çek")),
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  uploadProfilePhoto(image);
                },
                child: const Text("Galeriden Seç"))
          ],
        );
      },
    );
  }

  uploadProfilePhoto(XFile? photo) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    File file = File(photo!.path);
    var url = await userModel.uploadOgrProfilePhoto(
        userModel.users!.kresCode!,
        userModel.users!.kresAdi!,
        widget.teacher.teacherID,
        widget.teacher.adiSoyadi,
        "profil_foto",
        file);

    if (url != null) {
      widget.teacher.fotoUrl = url;
    }
    setState(() {});
  }

  saveTeacher(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    try {
      if (widget.teacher.fotoUrl != null) {
        //TODO: düzenlenecek bölüm.
        /* bool sonuc = await _userModel.saveTeacher(_userModel.users!.kresCode!,
            _userModel.users!.kresAdi!, widget.teacher);

        if (sonuc == true) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/LandingPage', (Route<dynamic> route) => false);
          Get.snackbar('Başarılı', 'Öğretmen kaydedildi.',
              snackPosition: SnackPosition.BOTTOM);
        }*/
      } else {
        Get.snackbar('Hata', 'Lütfen profil fotosu ekleyin.',
            snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      }
    } catch (e) {}
  }

  showPhoto() {
    return widget.teacher.fotoUrl == null
        ? const Center(
            child: Text(
            "Foto Ekle",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ))
        : ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(90)),
            child: Image.network(widget.teacher.fotoUrl!, fit: BoxFit.cover));
  }
}
