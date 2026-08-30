// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';

// import '../../firebase_options.dart';

// /// Initializes Firebase and reports success/failure so `main.dart` can
// /// decide between the real [FirestoreRecipeRepository] and the local
// /// [MockRecipeRepository] fallback (e.g. before `flutterfire configure`
// /// has been run for this project).
// abstract final class FirebaseService {
//   static Future<bool> initialize() async {
//     try {
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//       return true;
//     } catch (e, stack) {
//       // Expected until this project's real Firebase config is generated —
//       // logged rather than thrown so the app can still run against mock
//       // data during development.
//       debugPrint('Firebase initialization failed, using mock data: $e');
//       debugPrintStack(stackTrace: stack);
//       return false;
//     }
//   }
// }


import 'package:flutter/foundation.dart';

/// Firebase is intentionally disabled during local/mock-data development.
abstract final class FirebaseService {
  static Future<bool> initialize() async {
    debugPrint('Firebase is disabled. Using mock data.');
    return false;
  }
}