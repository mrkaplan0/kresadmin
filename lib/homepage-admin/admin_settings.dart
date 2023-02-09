import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/home_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/services/messaging_services.dart';
import 'package:provider/provider.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {

  final MessagingService _messagingService = MessagingService();

  @override
  void initState() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);


    _messagingService
        .initialize(onSelectNotification, context, userModel.users!)
        .then(
          (value) => firebaseCloudMessagingListeners(),
    );

    super.initState();
  }
  void firebaseCloudMessagingListeners() async {
    MessagingService.onMessage
        .listen(_messagingService.invokeLocalNotification);
    MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch);
  }

  _pageOpenForOnLaunch(RemoteMessage remoteMessage) {
    final Map<String, dynamic> message = remoteMessage.data;

    onSelectNotification(jsonEncode(message));
  }

  Future onSelectNotification(String? payload) async {}


  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(backgroundColor:const Color(0xFFF68763),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Yönetim Paneli",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black38),
            ),
            onPressed: () => _cikisyap(context),
            icon: const Icon(Icons.logout),
            label: const Text("Çıkış"),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              infoKres(context, userModel),
              Positioned(
                top: 200,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.00001,
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  children: [
                    MenuItems(
                      itemText: 'Personel İşlemleri',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PersonelManagement()));
                      },
                      icon: Icons.person,
                    ),
                    MenuItems(
                      itemText: ' Öğrenci İşlemleri',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StudentManagement()));
                      },
                      icon: Icons.school_rounded,
                    ),
                    MenuItems(
                      itemText: 'Kriter Ekle',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddCriteria()));
                      },
                      icon: Icons.star_half_rounded,
                    ),
                    MenuItems(
                      itemText: 'Bildirim Gönder',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SendNotification()));
                      },
                      icon: Icons.phone_android_outlined,
                    ),
                    MenuItems(
                      itemText: 'Anasayfa İşlemleri',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeSettings()));
                      },
                      icon: Icons.person,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoKres(BuildContext context, UserModel userModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 45),
      height: 230,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration( color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 0.6,spreadRadius:0.7,blurStyle: BlurStyle.outer)],

          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
      child: Container(
        decoration: const BoxDecoration(

            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              "Kreş Kodu ve Adı",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "${userModel.users!.kresCode} - ${userModel.users!.kresAdi}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 35),
            const Text(
              "Yönetici",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "${userModel.users!.username}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await userModel.signOut();
    return sonuc;
  }
}
