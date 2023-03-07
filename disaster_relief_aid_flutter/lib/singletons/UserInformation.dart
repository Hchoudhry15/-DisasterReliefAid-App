import 'package:firebase_auth/firebase_auth.dart';

class UserInformationSingleton {
  static final UserInformationSingleton _singleton =
      UserInformationSingleton._internal();

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory UserInformationSingleton() {
    return _singleton;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  UserInformationSingleton._internal() {
    // initialization logic goes here
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        _isUserLoaded = true;
      }
    });
  }
  bool _isUserLoaded = false;
  User? _firebaseUser;

  /// Returns true if the user is loaded, false otherwise. Call this method before accessing the user.
  bool isUserLoaded() {
    return _isUserLoaded;
  }

  /// Returns the current user. Call [isUserLoaded] before accessing this property.
  User? getFirebaseUser() {
    return _firebaseUser;
  }
}
