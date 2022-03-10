import 'dart:convert';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart' hide ImageSource;
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class PhotoEditor extends StatefulWidget {
  final Student? student;

  PhotoEditor({this.student});

  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  final GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey();
  final ImageEditorOption option = ImageEditorOption();
  int selectedIndex = 0;
  File? originalImage, editedImage;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Ekle'),
        actions: <Widget>[
          originalImage != null
              ? TextButton(
                  child: Text(
                    'Önizleme ve Kaydet',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    await previewAndSave();
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
                    SafeArea(child: buildImage()),
                    SizedBox(
                      height: 10,
                    ),
                    CheckboxListTile(
                      activeColor: Colors.orangeAccent.shade100,
                      onChanged: (value) => _onChange(value),
                      value: _showPhotoMainPage,
                      title: Text(
                        "Fotoğraf anasayfada gösterilsin.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    CheckboxListTile(
                      activeColor: Colors.orangeAccent.shade100,
                      onChanged: (value) => _onChangeTagStudent(value),
                      value: _tagStudent,
                      title: Text(
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
                      title: Text(
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
      bottomNavigationBar: _buildFunctions(),
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
              margin: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Text(
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
        SizedBox(
          height: 2,
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              child: Text(
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
      editedImage!,
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

  Widget _buildFunctions() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.flip),
          label: 'Çevir',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_left),
          label: 'Sola Döndür',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.rotate_right),
          label: 'Sağa Döndür',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.crop),
          label: 'Kırp',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            flip();
            break;
          case 1:
            rotate(false);
            break;
          case 2:
            rotate(true);
            break;
          case 3:
            crop();
            break;
        }
        setState(() {
          selectedIndex = index;
        });
      },
      currentIndex: selectedIndex,
      selectedItemColor: primarySwatch,
      unselectedItemColor: primaryColor.shade100,
    );
  }

  Future<void> previewAndSave() async {
    try {
      option.outputFormat = const OutputFormat.png();

      print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

      final File? result = await ImageEditor.editFileImageAndGetFile(
          file: editedImage!, imageEditorOption: option);

      print('result.length = ${result?.length}');

      if (result == null) return;

      showPreviewDialog(result);
    } catch (e) {
      debugPrint("hata............................");
    }
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState? state = editorKey.currentState;
    if (state == null) {
      return;
    }
    final EditActionDetails? action = editorKey.currentState!.editAction;
    final bool flipHorizontal = action!.flipY;
    final bool flipVertical = action.flipX;

    try {
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
      final Rect? rect = state.getCropRect();
      if (rect == null) {
        print('The crop rect is null.');
        return;
      }

      option.addOption(ClipOption.fromRect(rect));
    } catch (e) {
      debugPrint("hata......................" + e.toString());

      setState(() {
        editedImage = originalImage;
      });
    }
  }

  void flip() {
    final EditActionDetails? action = editorKey.currentState!.editAction;
    editorKey.currentState?.flip();
    final bool flipHorizontal = action!.flipY;
    final bool flipVertical = action.flipX;
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
  }

  void rotate(bool right) {
    final EditActionDetails? action = editorKey.currentState!.editAction;
    editorKey.currentState?.rotate(right: right);
    final double radian = action!.rotateAngle;
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }
  }

  void showPreviewDialog(File image) {
    showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) => Container(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.9),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox.fromSize(
                  size: const Size.square(300),
                  child: Container(
                    child: Image.file(image),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              if (_tagStudent == true && selectedStudent != null)
                Text(
                  "Etiket: " + selectedStudent!.adiSoyadi,
                  style: TextStyle(color: Colors.white),
                ),
              if (_addSpecialNote == true &&
                  specialNoteController.text.length > 0)
                Text(
                  "Not: " + specialNoteController.text,
                  style: TextStyle(color: Colors.white),
                ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 125,
                      child: ElevatedButton(
                          onPressed: () {
                            savePhoto(image);
                          },
                          child: Text("Kaydet"))),
                  SizedBox(
                    width: 125,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          option.reset();
                          setState(() {});
                        },
                        child: Text("İptal")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCamera() async {
    final XFile? result =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (result == null) {
      //  showToast('The pick file is null');
      return;
    }
    print(result.path);
    originalImage = editedImage = File(result.path);

    setState(() {});
  }

  Future<void> _pickGallery() async {
    final XFile? result =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result == null) {
      //  showToast('The pick file is null');
      return;
    }
    print(result.path);
    originalImage = editedImage = File(result.path);

    setState(() {});
  }

  Widget tagStudentToPhoto() {
    return DropdownButton<Student>(
      focusColor: Colors.white,
      value: selectedStudent,
      //elevation: 5,
      style: TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: studentList!.map<DropdownMenuItem<Student>>((Student value) {
        return DropdownMenuItem<Student>(
          value: value,
          child: Text(
            " ${value.adiSoyadi}",
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      hint: Text(
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
        decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            labelText: 'Özel Not',
            // hintText: 'Özel not giriniz...',
            suffixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
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

  savePhoto(File image) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    String photoUrl;
    Photo myPhoto;
    if (selectedStudent != null || widget.student != null) {
      String? ogrID;
      if (selectedStudent == null)
        ogrID = widget.student!.ogrID;
      else
        ogrID = selectedStudent!.ogrID;
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
          info: specialNoteController.text.length > 0
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
          info: specialNoteController.text.length > 0
              ? specialNoteController.text
              : null,
          isShowed: _showPhotoMainPage);
    }
    bool sonuc = await _userModel.savePhotoToMainGallery(
        _userModel.users!.kresCode!, _userModel.users!.kresAdi!, myPhoto);

    if (sonuc == true) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
