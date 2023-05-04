// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/services/messaging_services.dart';
import 'package:provider/provider.dart';
import '../homepage-admin/student_settings/fast_rating_page.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {

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
                      itemText: ' Öğrenci Listesi',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  StudentListPage()));
                      },
                      icon: Icons.school_rounded,
                    ),
                    MenuItems(
                      itemText: '      Öğrenci \n Değerlendirme',
                      onPress: () async {
                        final UserModel userModel =
                        Provider.of<UserModel>(context, listen: false);

                        List<Student> stuList=[];
                        await userModel
                            .getStudentFuture(userModel.users!.kresCode!,
                            userModel.users!.kresAdi!)
                            .then((value) => stuList = value);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FastRating(stuList)));
                      },
                      icon: Icons.star_rate_outlined,
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
              "Öğretmen",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "${userModel.users!.username}",
              style: const TextStyle(color: Colors.black, fontSize: 18),textAlign: TextAlign.center,
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
