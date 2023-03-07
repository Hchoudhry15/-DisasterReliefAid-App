import 'package:disaster_relief_aid_flutter/model/realtimeuserinfo.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

        // get the user data from the realtime database
        final database = FirebaseDatabase.instance.ref();
        final userRef = database.child('/users/');
        final usernameEntry = userRef.child(user.uid);
        try {
          usernameEntry.get().then((value) {
            _realtimeUserInfo = RealtimeUserInfo(value);
            _isRealtimeUserInfoLoaded = true;
            // print(user.uid);
            // print(_realtimeUserInfo?.userType);
          });
        } catch (e) {
          print("An error has occured");
          print(e);
        }
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

  bool _isRealtimeUserInfoLoaded = false;
  RealtimeUserInfo? _realtimeUserInfo;

  /// Returns true if the realtime user info is loaded, false otherwise. Call this method before accessing the user info.
  bool isRealtimeUserInfoLoaded() {
    return _isRealtimeUserInfoLoaded;
  }

  /// Returns the current user info. Call [isRealtimeUserInfoLoaded] before accessing this property.
  RealtimeUserInfo? getRealtimeUserInfo() {
    return _realtimeUserInfo;
  }
}
