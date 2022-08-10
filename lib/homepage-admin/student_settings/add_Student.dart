import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:intl/intl.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({Key? key}) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

enum CinsiyetSecimi { erkek, kiz }

class _AddStudentState extends State<AddStudent> {
  final ImagePicker _picker = ImagePicker();
  String? _ogrAdiSoyadi,
      _dogumTarihi,
      _sinifi,
      _cinsiyet,
      _veliAdiSoyadi,
      _veliTelefonNo,
      _ogrID,
      _url;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController, _ogrIDController;

  CinsiyetSecimi _cinsiyetSecimi = CinsiyetSecimi.erkek;

  @override
  void initState() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    super.initState();
    _dateController = TextEditingController();
    _ogrIDController = TextEditingController();
    _userModel
        .takeNewOgrID(_userModel.users!.kresCode!, _userModel.users!.kresAdi!)
        .then((value) => _ogrIDController.text = value);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _ogrIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Öğrenci Ekle',
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
                const SizedBox(
                  height: kdefaultPadding,
                ),
                ogrIDTextForm(context),
                const SizedBox(
                  height: 10,
                ),
                adiSoyadiTextForm(context),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                dogumtarihiFormField(context),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                RadioListTile<CinsiyetSecimi>(
                  value: CinsiyetSecimi.erkek,
                  groupValue: _cinsiyetSecimi,
                  onChanged: (CinsiyetSecimi? value) {
                    setState(() {
                      _cinsiyetSecimi = value!;
                    });
                  },
                  title: const Text("Erkek"),
                ),
                RadioListTile<CinsiyetSecimi>(
                  value: CinsiyetSecimi.kiz,
                  groupValue: _cinsiyetSecimi,
                  onChanged: (CinsiyetSecimi? value) {
                    setState(() {
                      _cinsiyetSecimi = value!;
                    });
                  },
                  title: const Text("Kız"),
                ),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                veliAdiSoyadiTextForm(context),
                const SizedBox(height: kdefaultPadding),
                veliTelefonNoTextForm(context),
                const SizedBox(height: kdefaultPadding),
                Card(
                  shape: Border.all(color: Theme.of(context).primaryColor),
                  child: ListTile(
                    leading: const Icon(Icons.add_a_photo_outlined),
                    title: const Text("Profil Fotosu Ekle"),
                    onTap: () => _editPhotoWithDialog(),
                  ),
                ),
                if (_url != null) ...[
                  const Text('Profil Fotosu Başarıyla Eklendi.')
                ],
                const SizedBox(height: kdefaultPadding),
                SocialLoginButton(
                    btnText: "Kaydet",
                    btnColor: Theme.of(context).primaryColor,
                    onPressed: () => saveStudent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget adiSoyadiTextForm(BuildContext context) {
    return TextFormField(
      initialValue: 'Ömer Kaplan',
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Öğrenci Adı',
          hintText: 'Ad Soyad giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onChanged: (String? ogrAdi) {
        _ogrAdiSoyadi = ogrAdi!;
      },
      onSaved: (String? ogrAdi) {
        _ogrAdiSoyadi = ogrAdi!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.isEmpty) return 'Öğrenci adı boş geçilemez!';
      },
    );
  }

  Widget ogrIDTextForm(BuildContext context) {
    return TextFormField(
      controller: _ogrIDController,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Öğrenci No',
          hintText: 'Öğrenci No giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.format_list_numbered_rounded),
          )),
      onSaved: (String? ogrID) {
        _ogrID = ogrID!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.isEmpty) return 'Öğrenci No boş geçilemez!';
      },
    );
  }

  Widget veliAdiSoyadiTextForm(BuildContext context) {
    return TextFormField(
      initialValue: 'Ömer Kaplan',
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Veli Adı',
          hintText: 'Ad Soyad giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onSaved: (String? veliAdi) {
        _veliAdiSoyadi = veliAdi!;
      },
      validator: (String? veliAdi) {
        if (veliAdi!.isEmpty) return 'Veli adı boş geçilemez!';
      },
    );
  }

  Widget veliTelefonNoTextForm(BuildContext context) {
    return TextFormField(
      initialValue: '3203942830',
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Veli Telefonu',
          hintText: 'Telefon No giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onSaved: (String? velitel) {
        _veliTelefonNo = velitel!;
      },
      validator: (String? _veliTelefonNo) {
        if (_veliTelefonNo!.isEmpty) return 'Veli telefonu boş geçilemez!';
      },
    );
  }

  Widget dogumtarihiFormField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      //initialValue: _dogumTarihi,
      keyboardType: TextInputType.datetime,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Doğum Tarihi',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.date_range_rounded),
          )),
      onTap: () async {
        DateTime time = DateTime.now();
        FocusScope.of(context).requestFocus(FocusNode());

        DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now());
        var dt = DateTime(picked!.year, picked.month, picked.day);
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String _formattedTime = formatter.format(dt);

        if (picked != null && picked != time) {
          _dateController.text = _formattedTime; // add this line.
          setState(() {
            _dogumTarihi = _formattedTime;
            time = picked;
          });
        }
      },
      onSaved: (String? dogumTarihi) {
        _dogumTarihi = dogumTarihi!;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Doğum tarihi boş olamaz!';
        }
        return null;
      },
    );
  }

  saveStudent(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_cinsiyetSecimi == CinsiyetSecimi.erkek) {
        _cinsiyet = 'Erkek';
      } else {
        _cinsiyet = 'Kız';
      }

      Student newStu = Student(
          kresCode: _userModel.users!.kresCode,
          kresAdi: _userModel.users!.kresAdi,
          ogrID: _ogrID!,
          adiSoyadi: _ogrAdiSoyadi!,
          dogumTarihi: _dogumTarihi,
          cinsiyet: _cinsiyet,
          veliAdiSoyadi: _veliAdiSoyadi,
          veliTelefonNo: _veliTelefonNo,
          sinifi: _sinifi,
          fotoUrl: _url ?? "");
      bool sonuc = await _userModel.saveStudent(
          _userModel.users!.kresCode!, _userModel.users!.kresAdi!, newStu);

      if (sonuc == true) {
        Navigator.pop(context);
        Get.snackbar('Kayıt Başarılı', 'Öğrenci kaydedildi.',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Hata', 'Öğrenci kaydedilirken hata oluştu.',
            colorText: Colors.red, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  Future<void> _editPhotoWithDialog() async {
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
                      Navigator.pop(context);
                      // Capture a photo
                      final XFile? photo = await _picker.pickImage(
                          source: ImageSource.camera, imageQuality: 35);

                      uploadProfilePhoto(photo);
                    },
                    child: const Text("Foto Çek")),
                ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      // Pick an image
                      final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 35);

                      uploadProfilePhoto(image);
                    },
                    child: const Text("Galeriden Seç"))
              ],
            ),
          ],
        );
      },
    );
  }

  uploadProfilePhoto(XFile? photo) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    File file = File(photo!.path);
    var url = await _userModel.uploadOgrProfilePhoto(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        _ogrIDController.text,
        _ogrAdiSoyadi!,
        "profil_foto",
        file);

    if (url != null) {
      _url = url;
      debugPrint(_url);
      debugPrint(url);
    }
    setState(() {});
  }
}
