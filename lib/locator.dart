import 'package:get_it/get_it.dart';
import 'package:kresadmin/repository/user_repository.dart';
import 'package:kresadmin/services/FirebaseAuthServices.dart';
import 'package:kresadmin/services/firestore_db_service.dart';
import 'package:kresadmin/services/sending_notification_service.dart';
import 'package:kresadmin/services/storage_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => SendingNotificationService());
}
