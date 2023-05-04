import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';

import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PhotoEditor extends StatefulWidget {
  final Student? student;
File editedPhoto;

  PhotoEditor({Key? key, this.student, required this.editedPhoto}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {


  File? originalImage;

  List<Student>? studentList;
  Student? selectedStudent;
  late TextEditingController specialNoteController;
  bool _showPhotoMainPage = false;
  bool _addSpecialNote = false;
  bool _tagStudent = false;


  @override
  void initState() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    super.initState();
    userModel
        .getStudents(userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .listen((event) {
      studentList = event;
    });
    if (widget.student != null) _tagStudent = true;


    specialNoteController = TextEditingController();

  }

  @override
  void dispose() {
    specialNoteController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Ekle'),
        actions: <Widget>[
          TextButton(
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await savePhoto(widget.editedPhoto);
                  },
                )
              ,
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              // SafeArea(child: buildImage()),

              SizedBox(
                  height: MediaQuery.of(context).size.height / 3*1.1,
                  width: MediaQuery.of(context).size.width / 1.6,
                  child: Card(elevation: 4,child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(widget.editedPhoto ),
                  ))),
              const SizedBox(height: 16),

              CheckboxListTile(
                activeColor: Colors.orangeAccent.shade100,
                onChanged: (value) => _onChange(value),
                value: _showPhotoMainPage,
                title: const Text(
                  "Fotoğraf anasayfada gösterilsin.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              CheckboxListTile(
                activeColor: Colors.orangeAccent.shade100,
                onChanged: (value) => _onChangeTagStudent(value),
                value: _tagStudent,
                title: const Text(
                  "Öğrenci Etiketle.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              if (_tagStudent == true && widget.student == null)
                tagStudentToPhoto(),
              if (_tagStudent == true && widget.student != null)
                Text("Etiket: ${widget.student!.adiSoyadi}"),
              CheckboxListTile(
                activeColor: Colors.orangeAccent.shade100,
                onChanged: (value) => _onChangeSpecialNote(value),
                value: _addSpecialNote,
                title: const Text(
                  "Not ekle.",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              if (_addSpecialNote == true) specialNoteTextForm(context),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: _buildFunctions(),
    );
  }

  _onChange(bool? value) {
    setState(() {
      _showPhotoMainPage = value!;
    });
  }

  _onChangeTagStudent(bool? value) {
    setState(() {
      _tagStudent = value!;
    });
  }





  Widget tagStudentToPhoto() {
    return DropdownButton<Student>(
      focusColor: Colors.white,
      value: selectedStudent,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: studentList!.map<DropdownMenuItem<Student>>((Student value) {
        return DropdownMenuItem<Student>(
          value: value,
          child: Text(
            " ${value.adiSoyadi}",
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: const Text(
        "Öğrenci seçiniz",
        style: TextStyle(color: Colors.black),
      ),
      onChanged: (Student? value) {
        setState(() {
          selectedStudent = value!;
        });
      },
    );
  }

  Widget specialNoteTextForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: specialNoteController,
        decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            labelText: 'Özel Not',
            // hintText: 'Özel not giriniz...',
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Icon(Icons.notes_outlined),
            )),
        maxLines: 4,
      ),
    );
  }

  _onChangeSpecialNote(bool? value) {
    setState(() {
      _addSpecialNote = value!;
    });
  }

  savePhoto(File imagee) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    String photoUrl;
    Photo myPhoto;


    if (selectedStudent != null || widget.student != null) {
      String? ogrID;
      if (selectedStudent == null) {
        ogrID = widget.student!.ogrID;
      } else {
        ogrID = selectedStudent!.ogrID;
      }
      photoUrl = await userModel.uploadPhotoToGallery(
          userModel.users!.kresCode!,
          userModel.users!.kresAdi!,
          ogrID,
          '',
          'Gallery',
          imagee);
      myPhoto = Photo(
          photoUrl: photoUrl,
          time: DateTime.now().toString(),
          info: specialNoteController.text.isNotEmpty
              ? specialNoteController.text
              : null,
          ogrID: ogrID,
          isShowed: _showPhotoMainPage);
      bool sonuc = await userModel.savePhotoToSpecialGallery(
          userModel.users!.kresCode!, userModel.users!.kresAdi!, myPhoto);
      if (sonuc == true) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);

      }
    } else {
      photoUrl = await userModel.uploadPhotoToGallery(
          userModel.users!.kresCode!,
          userModel.users!.kresAdi!,
          'Main',
          '',
          'Gallery',
          imagee);
      myPhoto = Photo(
          photoUrl: photoUrl,
          time: DateTime.now().toString(),
          info: specialNoteController.text.isNotEmpty
              ? specialNoteController.text
              : null,
          isShowed: _showPhotoMainPage);
    }
    bool sonuc = await userModel.savePhotoToMainGallery(
        userModel.users!.kresCode!, userModel.users!.kresAdi!, myPhoto);

    if (sonuc == true && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget showProgressIndicator() {
    return const Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
