// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/services/messaging_services.dart';
import 'package:provider/provider.dart';

class TeacherLandingPage extends StatefulWidget {

final MyUser user;

  const TeacherLandingPage( {Key? key, required this.user}) : super(key: key);


  @override
  _TeacherLandingPageState createState() => _TeacherLandingPageState();
}

class _TeacherLandingPageState extends State<TeacherLandingPage> {
  String? tk;
  bool checking=false;
  final MessagingService _messagingService = MessagingService();

  @override
  void initState() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    userModel
        .getYoneticiToken(
            userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
debugPrint("mesaj gönder token init $value");
      tk = value;
      userModel
          .sendNotificationToYonetici(userModel.users!, tk!)
          .then((value) =>   setState(() {checking=true;}));

    });
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

  Future onSelectNotification(String? payload) async {

  await _cikisyap(context);
  }

  @override
  Widget build(BuildContext context) {



     if(checking==true){ return Scaffold(appBar: AppBar(actions: [IconButton(onPressed:()=> _cikisyap, icon: const Icon(Icons.logout))],),
        body: Container(
            alignment: Alignment.center,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  "Kaydınızı tamamlamak için yöneticiye bir adet bildirim gönderildi. Lütfen bekleyin ve tekrardan giriş yapın."),
            )),
      );
    } else {
      return Scaffold( appBar: AppBar(actions: [IconButton(onPressed:()=> _cikisyap, icon: const Icon(Icons.logout))],),
          body: Container(
              alignment: Alignment.center,
              child: const Text("Kaydınız tamamlanamadı.")),    );}



  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await userModel.signOut();
    return sonuc;
  }
}
