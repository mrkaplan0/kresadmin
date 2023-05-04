import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/locator.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/services/sending_notification_service.dart';
import 'package:provider/provider.dart';

BuildContext? myContext;

class MessagingService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final SendingNotificationService _sendingNotificationService =
      locator<SendingNotificationService>();
  static final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  static Future<void> _requestPermission() async {
    if (Platform.isAndroid) return;

    await _messaging.requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;
  static Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;
// TODO: Local Notification package will be updated.
  Future<void> initialize(SelectNotificationCallback onSelectNotification,
      BuildContext context, MyUser user) async {
    myContext = context;

    await _requestPermission();

    await _initializeLocalNotification(onSelectNotification);
    await _configureAndroidChannel();

    await _openInitialScreenFromMessage(onSelectNotification);
  }

  invokeLocalNotification(RemoteMessage remoteMessage) async {
    RemoteNotification? notification = remoteMessage.notification;
    AndroidNotification? android = remoteMessage.notification?.android;
    if (notification != null && android != null) {
      await _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'BreakingCodeChannel', // id
            'High Importance Notifications', // title

            icon: android.smallIcon,
          ),
        ),
        payload: jsonEncode(remoteMessage.data),
      );
    }
    if (remoteMessage.data.isNotEmpty) {
      if (remoteMessage.data.containsKey('gonderenUserID')) {
        await showDialogToYonetici(remoteMessage);
      } else {
        await showDialogToPersonel(remoteMessage);
      }
    }
  }

  Future<void> showDialogToYonetici(RemoteMessage remoteMessage) async {
    showDialog(
        context: myContext!,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text(remoteMessage.data['title']),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(remoteMessage.data['message']),
              ),
              ButtonBar(
                children: [

                  ElevatedButton(
                    onPressed: () async {
                      try {

                        final UserModel userModel =
                            Provider.of<UserModel>(context, listen: false);
                        bool sonuc = await userModel.updateTeacherAuthorisation(userModel.users!.kresCode!, userModel.users!.kresAdi!, remoteMessage.data['gonderenUserID'],);

                        if (sonuc == true) {
                          Navigator.of(context).pop();
                          Get.snackbar('İşlem Tamam!', 'Kayıt Tamamlandı.',
                              snackPosition: SnackPosition.BOTTOM);
                          _sendingNotificationService
                              .sendNotificationToTeacher(
                                  remoteMessage.data['gönderenUserToken'], " Kaydınız tamamlandı.");
                        } else {
                          Get.snackbar('HATA',
                              'Kayıt işlemi başarısız, lütfen tekrar deneyiniz.');
                        }
                      } catch (e) {
                        debugPrint(
                            'Personel ekleme arama hatası $e');
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orangeAccent)),
                    child: const Text("Kaydet"),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueGrey)),
                    child: const Text("İptal"),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> showDialogToPersonel(RemoteMessage remoteMessage) async {
    showDialog(
        barrierDismissible: false,
        context: myContext!,
        builder: (BuildContext context) {
          final UserModel userModel =
              Provider.of<UserModel>(context, listen: false);
          return SimpleDialog(
            title: Text(remoteMessage.data['title']),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(remoteMessage.data['message']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    await userModel.signOut();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orangeAccent)),
                  child: const Text("Tamam"),
                ),
              ),
            ],
          );
        });
  }

  static Future<void> _configureAndroidChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'BreakingCodeChannel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.max,
    );

    await _localNotification
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _openInitialScreenFromMessage(
    SelectNotificationCallback onSelectNotification,
  ) async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage?.data != null) {
      _handleMessage(initialMessage!);
    }


    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage remoteMessage) async {
    if (remoteMessage.data.containsKey('gonderenUserID')) {
      await showDialogToYonetici(remoteMessage);
    } else {
      await showDialogToPersonel(remoteMessage);
    }
  }

  static Future<void> _initializeLocalNotification(
    SelectNotificationCallback onSelectNotification,
  ) async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const ios = IOSInitializationSettings();

    const initSetting = InitializationSettings(android: android, iOS: ios);

    await _localNotification.initialize(
      initSetting,
      onSelectNotification: onSelectNotification,
    );
  }
}
