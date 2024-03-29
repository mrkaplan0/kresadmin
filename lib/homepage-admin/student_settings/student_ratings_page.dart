import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class StudentRating extends StatefulWidget {
  final Student student;

  const StudentRating(this.student);

  @override
  _StudentRatingState createState() => _StudentRatingState();
}

class _StudentRatingState extends State<StudentRating> {
  Map<String, dynamic> ratingMap = {};
  DateTime dateTime = DateTime.now();
  bool addSpecialNote = false;
  late TextEditingController specialNoteController;
  final bool _showPhotoMainPage = false;

  @override
  void initState() {
    super.initState();
    specialNoteController = TextEditingController();
  }

  @override
  void dispose() {
    specialNoteController.dispose();
    super.dispose();
  }

  Widget dynamicCriteriaList() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return FutureBuilder<List<String>>(
        future: _userModel.getCriteria(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var criteriaList = sonuc.data!;
            if (criteriaList.isNotEmpty) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: criteriaList.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                criteriaList[i],
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: RatingBar(
                                initialRating: 3,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  half: const Icon(
                                    Icons.star_half_rounded,
                                    color: Colors.amber,
                                  ),
                                  empty: const Icon(
                                    Icons.star_border_rounded,
                                    color: Colors.amber,
                                  ),
                                ),
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                onRatingUpdate: (rating) {
                                  ratingMap
                                      .addAll({criteriaList[i]: rating});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("Kriter ekleyin."),
              );
            }
          } else {
            return const Center(
              child: Text("Kriter ekleyin."),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    final String formattedTime = formatter.format(dateTime);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: itemColor3,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 28,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      widget.student.fotoUrl != null
                          ? SizedBox(
                              width: 80,
                              height: 80,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(40)),
                                child: Image.network(
                                  widget.student.fotoUrl!,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.student.adiSoyadi,
                            style: const TextStyle(fontSize: 24),
                          ),
                          Text("Öğrenci No: ${widget.student.ogrID}"),
                          Text("Tarih: $formattedTime")
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: kdefaultPadding),
                dynamicCriteriaList(),
                if (addSpecialNote == true) specialNoteTextForm(context),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          addSpecialNote == false
                              ? addSpecialNote = true
                              : addSpecialNote = false;
                          setState(() {});
                        },
                        child: const Text("Özel Not Ekle")),
                  ],
                ),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      saveRatings(formattedTime);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orangeAccent.shade100,
                    ),
                    child: const Text("Değerlendirmeyi Kaydet"),
                  ),
                ),
                const SizedBox(
                  height: kdefaultPadding,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget specialNoteTextForm(BuildContext context) {
    return TextFormField(
      controller: specialNoteController,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Özel Not',
          // hintText: 'Özel not giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      maxLines: 4,
    );
  }

  saveRatings(String time) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    ratingMap.addAll({'Değerlendirme Tarihi': time});
    if (addSpecialNote == true && specialNoteController.text.isNotEmpty) {
      ratingMap.addAll({'Özel Not': specialNoteController.text});
    }

    bool ss = await _userModel.saveRatings(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        widget.student.ogrID,
        ratingMap,
        _showPhotoMainPage);

    if (ss == true) {
      Get.snackbar("Başarılı", "Değerlendirme Kaydedildi");
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
