import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/personel_settings/add_teacher_photo.dart';
import 'package:kresadmin/models/teacher.dart';
import 'package:provider/provider.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({Key? key}) : super(key: key);

  @override
  _AddTeacherState createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  String? _teachAdiSoyadi, _teachTelefon, _sinifi, _teachID, _fotoUrl;

  String _buttonText = "Kaydet";
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Öğretmen Ekle',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: kdefaultPadding,
                ),
                teacherIDTextForm(context),
                SizedBox(
                  height: 10,
                ),
                teacherAdiSoyadi(context),
                SizedBox(
                  height: kdefaultPadding,
                ),
                teacherTelefonTextForm(context),
                SizedBox(
                  height: kdefaultPadding,
                ),
                sinifiTextForm(context),
                SizedBox(
                  height: kdefaultPadding,
                ),
                SocialLoginButton(
                    btnText: _buttonText,
                    btnColor: Theme.of(context).primaryColor,
                    onPressed: () => saveTeacher(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sinifiTextForm(BuildContext context) {
    return TextFormField(
      initialValue: 'A',
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Sınıf Bilgisi',
          hintText: 'Sınıfını giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.class__rounded),
          )),
      onSaved: (String? sinifi) {
        _sinifi = sinifi!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.length < 1)
          return 'Öğretmenin sınıfı boş geçilemez!, tek sınıfsa A giriniz.';
      },
    );
  }

  Widget teacherIDTextForm(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Öğretmen No',
          hintText: 'Öğretmen No giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.format_list_numbered_rounded),
          )),
      onSaved: (String? teacID) {
        _teachID = teacID!;
      },
      validator: (String? teachID) {
        if (teachID!.length < 5)
          return 'Öğrenci No boş geçilemez ve en az 5 haneli olmalıdır!';
      },
    );
  }

  Widget teacherAdiSoyadi(BuildContext context) {
    return TextFormField(
      initialValue: 'Mr. Kaplan',
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Öğretmen Adı',
          hintText: 'Ad Soyad giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onSaved: (String? teachAdiSoyadi) {
        _teachAdiSoyadi = teachAdiSoyadi!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.length < 1) return 'Öğretmen adı boş geçilemez!';
      },
    );
  }

  saveTeacher(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Teacher teacher = Teacher(
            teacherID: _teachID!,
            adiSoyadi: _teachAdiSoyadi!,
            telefonNo: _teachTelefon,
            sinifi: _sinifi);

        bool sonuc = await _userModel.saveTeacher(teacher);

        if (sonuc == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTeacherPhoto(teacher)));
          Get.snackbar('Başarılı', 'Öğretmen kaydedildi.',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('Hata', 'Öğretmen kaydedilirken hata oluştu.',
            colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Widget teacherTelefonTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: '123454546',
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Veli Cep Telefonu',
          hintText: 'Cep no giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onSaved: (String? tel) {
        _teachTelefon = tel!;
      },
      validator: (String? tel) {
        if (tel!.length < 1) return 'Öğretmen telefonu boş geçilemez!';
      },
    );
  }

  Widget photoWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => photoFrom(),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(90)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor, width: 3),
                  shape: BoxShape.circle,
                  color: Colors.orangeAccent.shade100),
              height: 150,
              width: 150,
              child: showPhoto(),
            ),
          ),
          Positioned(
            child: Icon(
              Icons.add_a_photo_rounded,
              color: primaryColor,
              size: 40,
            ),
            bottom: 7,
            right: 7,
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
                child: Text("Foto Çek")),
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                  // Pick an image
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);

                  uploadProfilePhoto(image);
                },
                child: Text("Galeriden Seç"))
          ],
        );
      },
    );
  }

  uploadProfilePhoto(XFile? photo) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    File file = File(photo!.path);
    var url = await _userModel.uploadOgrProfilePhoto(
        _teachID!, _teachAdiSoyadi!, "profil_foto", file);

    if (url != null) {
      _fotoUrl = url;
      print(url);
    }
    setState(() {});
  }

  showPhoto() {
    return _fotoUrl == null
        ? Center(
            child: Text(
            "Foto Ekle",
            style: TextStyle(fontSize: 22, color: Colors.white),
          ))
        : Image.network(_fotoUrl!, fit: BoxFit.cover);
  }
}
