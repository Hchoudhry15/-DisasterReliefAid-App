import 'package:firebase_database/firebase_database.dart';

/// This file is used to store the user information that we get from the realtime database.
class RealtimeUserInfo {
  UserType? userType;
  DateTime? birthdate;
  String? fname;
  String? language;
  List<String>? vulnerabilities;

  RealtimeUserInfo(DataSnapshot snapshot) {
    for (var element in snapshot.children) {
      switch (element.key) {
        case "userType":
          userType = UserType.values
              .firstWhere((e) => e.toString() == "UserType.${element.value}");
          break;
        case "birthdate":
          birthdate = DateTime.parse(element.value.toString());
          break;
        case "fname":
          fname = element.value.toString();
          break;
        case "language":
          language = element.value.toString();
          break;
        case "vulnerabilities":
          vulnerabilities = List<String>.from(element.value.toString().split(","));
          break;
      }
    }
  }
}

enum UserType {
  /// A user that is a volunteer.
  Volunteer,

  /// The base user (victim).
  User,
}
