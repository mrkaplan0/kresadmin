import 'dart:io';
import 'dart:typed_data';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class PhotoEditor extends StatefulWidget {
  final Student? student;

  PhotoEditor({Key? key, this.student}) : super(key: key);

  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();

  File? originalImage;
  Uint8List? imageData, editedImage;
  List<Student>? studentList;
  Student? selectedStudent;
  late TextEditingController specialNoteController;
  bool _showPhotoMainPage = false;
  bool _addSpecialNote = false;
  bool _tagStudent = false;

  @override
  void initState() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    super.initState();
    _userModel
        .getStudents(_userModel.users!.kresCode!, _userModel.users!.kresAdi!)
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
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Ekle'),
        actions: <Widget>[
          originalImage != null
              ? TextButton(
                  child: const Text(
                    'Kaydet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await savePhoto(editedImage);
                  },
                )
              : Container(),
        ],
      ),
      body: originalImage != null
          ? SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // SafeArea(child: buildImage()),
                    if (imageData != null)
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Image.memory(imageData!)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: const Text("Düzenle"),
                      onPressed: () async {
                        editedImage = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageEditor(
                              image: imageData,
                            ),
                          ),
                        );

                        // replace with edited image
                        if (editedImage != null) {
                          imageData = editedImage;
                          setState(() {});
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
            )
          : photoFrom(),
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

  Widget photoFrom() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: const Text(
                "Fotoğraf Çek",
                style: TextStyle(fontSize: 24),
              ),
              decoration: BoxDecoration(
                  color: Colors.orangeAccent.shade100.withOpacity(0.1),
                  border: Border.all(color: Colors.orangeAccent.shade100)),
            ),
            onTap: () {
              _pickCamera();
            },
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: const Text(
                "Galeriden Yükle",
                style: TextStyle(fontSize: 24),
              ),
              decoration: BoxDecoration(
                  color: Colors.orangeAccent.shade100.withOpacity(0.5),
                  border: Border.all(color: Colors.orangeAccent.shade100)),
            ),
            onTap: () {
              _pickGallery();
            },
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    return ExtendedImage.file(
      originalImage!,
      height: 300,
      width: 300,
      extendedImageEditorKey: editorKey,
      mode: ExtendedImageMode.editor,
      fit: BoxFit.contain,
      cacheRawData: true,
      initEditorConfigHandler: (_) => EditorConfig(
        maxScale: 5.0,
        cropRectPadding: const EdgeInsets.all(20.0),
        hitTestSize: 10.0,
      ),
    );
  }

  Future<void> _pickCamera() async {
    final XFile? result = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 45);

    if (result == null) {
      return;
    }
    originalImage = File(result.path);

    var data = await rootBundle.load(result.path);
    setState(() {
      imageData = data.buffer.asUint8List();
    });
  }

  Future<void> _pickGallery() async {
    final XFile? result = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);

    if (result == null) {
      return;
    }

    originalImage = File(result.path);
    imageData = await originalImage!.readAsBytes();
    setState(() {});
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

  savePhoto(Uint8List? imagee) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    String photoUrl;
    Photo myPhoto;
    File image;
    if (imagee != null) {
      image = File.fromRawPath(imagee);
    } else {
      image = originalImage!;
    }
    if (selectedStudent != null || widget.student != null) {
      String? ogrID;
      if (selectedStudent == null) {
        ogrID = widget.student!.ogrID;
      } else {
        ogrID = selectedStudent!.ogrID;
      }
      photoUrl = await _userModel.uploadPhotoToGallery(
          _userModel.users!.kresCode!,
          _userModel.users!.kresAdi!,
          ogrID,
          '',
          'Gallery',
          image);
      myPhoto = Photo(
          photoUrl: photoUrl,
          time: DateTime.now().toString(),
          info: specialNoteController.text.isNotEmpty
              ? specialNoteController.text
              : null,
          ogrID: ogrID,
          isShowed: _showPhotoMainPage);
      bool sonuc = await _userModel.savePhotoToSpecialGallery(
          _userModel.users!.kresCode!, _userModel.users!.kresAdi!, myPhoto);
      if (sonuc == true) {
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } else {
      photoUrl = await _userModel.uploadPhotoToGallery(
          _userModel.users!.kresCode!,
          _userModel.users!.kresAdi!,
          'Main',
          '',
          'Gallery',
          image);
      myPhoto = Photo(
          photoUrl: photoUrl,
          time: DateTime.now().toString(),
          info: specialNoteController.text.isNotEmpty
              ? specialNoteController.text
              : null,
          isShowed: _showPhotoMainPage);
    }
    bool sonuc = await _userModel.savePhotoToMainGallery(
        _userModel.users!.kresCode!, _userModel.users!.kresAdi!, myPhoto);

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
