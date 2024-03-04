// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class SendNotification extends StatefulWidget {
  const SendNotification({Key? key}) : super(key: key);

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  final _formKey = GlobalKey<FormState>();
  Student? selectedStudent;
  List<Student>? studentList;
  String? message;

  @override
  void initState() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    super.initState();
    _userModel
        .getStudents(_userModel.users!.kresCode!, _userModel.users!.kresAdi!)
        .listen((event) {
      setState(() {
        studentList = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirim Servisi"),
      ),
      body: Column(
        children: [
          tagStudentToNotification(),
          const SizedBox(
            height: 10,
          ),
          specialNoteTextForm(context),
          CustomButton(
              btnText: 'Bildirim Gönder',
              btnColor: Theme.of(context).primaryColor,
              onPressed: () => sendNotification(context)),
        ],
      ),
    );
  }

  Widget tagStudentToNotification() {
    return DropdownButton<Student>(
      focusColor: Colors.white,
      value: selectedStudent,
      //elevation: 5,
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.black,
      items: studentList?.map<DropdownMenuItem<Student>>((Student value) {
        return DropdownMenuItem<Student>(
          value: value,
          child: Text(
            "${value.ogrID} - ${value.adiSoyadi}",
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
        debugPrint(selectedStudent.toString());
      },
    );
  }

  Widget specialNoteTextForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              labelText: 'Bildirim',
              suffixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                child: Icon(Icons.notes_outlined),
              )),
          maxLines: 4,
          onSaved: (String? d) {
            message = d!;
          },
          validator: (String? not) {
            if (not!.isEmpty) return 'Duyuru ekleyin!';
            return null;
          },
        ),
      ),
    );
  }

  Future sendNotification(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _userModel.sendNotificationToParent(selectedStudent!.token!, message!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Islem Tamam.'),
      ));
    }
  }
}
