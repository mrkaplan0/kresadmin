import 'package:flutter/material.dart';
import 'package:kresadmin/common_widget/student_profile_widget.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/photo_editor.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_ratings_page.dart';
import 'package:kresadmin/models/student.dart';

class StudentDetailPage extends StatefulWidget {
  final Student student;

  // ignore: use_key_in_widget_constructors
  const StudentDetailPage(this.student);

  @override
  _StudentDetailPageState createState() => _StudentDetailPageState();
}

class _StudentDetailPageState extends State<StudentDetailPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenci Bilgi Ekranı"),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 7,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: StudentProfileWidget(widget.student)),
            const SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentRating(widget.student)));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade100,
                  ),
                  child: const Text("Değerlendirme Yap",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhotoEditor(
                                  student: widget.student,
                                )));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orangeAccent.shade100,
                  ),
                  child: const Text("Fotoğref Ekle",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
