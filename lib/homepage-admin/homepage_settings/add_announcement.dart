import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class AddAnnouncement extends StatefulWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final _formKey = GlobalKey<FormState>();
  String? announcementTitle, announcementBody;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Duyuru Ekle',
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
                announcementTitleTextForm(context),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                announcementBodyTextForm(context),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                const SizedBox(
                  height: kdefaultPadding,
                ),
                SocialLoginButton(
                    btnText: 'Duyuru Ekle',
                    btnColor: Theme.of(context).primaryColor,
                    onPressed: () => addAnnouncement(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget announcementTitleTextForm(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Duyuru Ba??l??????',
          hintText: 'Duyuruyu k??saca tan??mlay??n.',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.text_fields_rounded),
          )),
      onSaved: (String? d) {
        announcementTitle = d!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.isEmpty) return 'Duyuru ba??l??????n?? bo?? b??rakt??n??z!';
        return null;
      },
    );
  }

  Widget announcementBodyTextForm(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Duyuru',
          hintText: 'Duyuruyu ekleyin.',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.textsms_rounded),
          )),
      minLines: 3,
      maxLines: 5,
      onSaved: (String? d) {
        announcementBody = d!;
      },
      validator: (String? ogrAdi) {
        if (ogrAdi!.isEmpty) return 'Duyuru ekleyin!';
        return null;
      },
    );
  }

  Future addAnnouncement(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DateTime dateTime = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

      String formattedTime = formatter.format(dateTime);

      Map<String, dynamic> announcement = {
        'Duyuru Ba??l??????': announcementTitle,
        'Duyuru': announcementBody,
        'Duyuru Tarihi': formattedTime
      };

      var sonuc = await _userModel.addAnnouncement(_userModel.users!.kresCode!,
          _userModel.users!.kresAdi!, announcement);

      if (sonuc) Navigator.pop(context);
      Get.snackbar('Ba??ar??l??', 'Duyuru Eklendi.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
