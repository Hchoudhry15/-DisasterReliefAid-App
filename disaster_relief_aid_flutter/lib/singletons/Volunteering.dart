import 'package:cron/cron.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteeringSingleton {
  static final VolunteeringSingleton _volunteeringSingleton =
      VolunteeringSingleton._internal();

  factory VolunteeringSingleton() {
    return _volunteeringSingleton;
  }

  VolunteeringSingleton._internal() {
    cron = Cron();
    database = FirebaseDatabase.instance.ref();
  }

  Future startVolunteering() async {
    if (currentJob != null) {
      await currentJob!.cancel();
    }
    await attemptVolunteering();
    currentJob = cron.schedule(Schedule.parse("*/20 * * * * *"), () async {
      await attemptVolunteering();
      print("Update Volunteer location!");
    });
  }

  Future attemptVolunteering() async {
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user != null) {
      await addActiveVolunteer(user.uid);
    } else {
      print("The user is currently null");
    }
  }

  Future stopVolunteering() async {
    if (currentJob != null) {
      await currentJob!.cancel();
    }
  }

  late Cron cron;
  ScheduledTask? currentJob;
  late DatabaseReference database;

  get isCurrentlyVolunteering {
    return currentJob != null;
  }

  Future addActiveVolunteer(String uID) async {
    final userRef = database.child('/activevolunteerlist/');
    var userID = uID;
    final userEntry = userRef.child(userID);
    try {
      Position location = await Location.determinePosition();
      await userEntry.update({
        'timestamp': DateTime.now().toString(),
        'location': location.toJson()
      });
    } catch (e) {
      print("An error has occured");
      print(e);
    }
  }
}
