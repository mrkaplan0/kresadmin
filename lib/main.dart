import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/landing_page.dart';

import 'package:provider/provider.dart';
import 'View_models/user_model.dart';
import 'constants.dart';

import 'locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(
      "Handling a background message: ${message.messageId} ve ${message.data}");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => UserModel(),
            child: GetMaterialApp(
              routes: {
                '/LandingPage': (context) => LandingPage(),
                '/StudentManagement': (context) => StudentManagement(),
                '/StudentListPage': (context) => StudentListPage(),
              },
              theme: ThemeData(
                  primarySwatch: primarySwatch,
                  primaryColor: primaryColor,
                  textTheme: Theme.of(context)
                      .textTheme
                      .apply(displayColor: textColor),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.all(kdefaultPadding),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: textFieldBorder,
                    enabledBorder: textFieldBorder,
                    focusedBorder: textFieldBorder,
                  ),
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white, elevation: 0)),
              debugShowCheckedModeBanner: false,
              home: LandingPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
