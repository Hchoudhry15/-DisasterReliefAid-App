import 'dart:async';

import 'package:cron/cron.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/model/helprequest.model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VolunteeringSingleton {
  static final VolunteeringSingleton _volunteeringSingleton =
      VolunteeringSingleton._internal();

  late Cron cron;
  ScheduledTask? currentJob;
  late DatabaseReference database;

  StreamSubscription<DatabaseEvent>? onAddedListener;
  StreamSubscription<DatabaseEvent>? onUpdatedListener;

  StreamController onHelpRequestReceived = StreamController.broadcast();
  Stream get onHelpRequestReceivedStream => onHelpRequestReceived.stream;

  StreamController onHelpRequestAccepted = StreamController.broadcast();
  Stream get onHelpRequestAcceptedStream => onHelpRequestAccepted.stream;

  bool awaitingHelpRequestResponse = false;
  String helpRequestMessage = "";
  String helpRequestDistance = "";
  String helpRequestID = "";
  String helpRequestLongitude = "";
  String helpRequestLatitude = "";

  HelpRequest? currentHelpRequest;

  factory VolunteeringSingleton() {
    return _volunteeringSingleton;
  }

  VolunteeringSingleton._internal() {
    cron = Cron();
    database = FirebaseDatabase.instance.ref();
    onAddedListener = null;
    onUpdatedListener = null;
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

    User? user = UserInformationSingleton().getFirebaseUser();
    final userRef = database.child('/activevolunteerlist/');
    final userEntry = userRef.child(user!.uid);

    // create a subscription to wait for the data to be updated (or added)
    onAddedListener = userEntry.onChildAdded.listen(onAddedOrUpdated);
    onUpdatedListener = userEntry.onChildChanged.listen(onAddedOrUpdated);
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
    if (onAddedListener != null) {
      await onAddedListener!.cancel();
    }
    if (onUpdatedListener != null) {
      await onUpdatedListener!.cancel();
    }
  }

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

  /// This function is called when the Volunteer's entry is updated
  void onAddedOrUpdated(DatabaseEvent event) {
    // check if a user's request has been sent here.
    if (event.snapshot.key == "helpRequest") {
      dynamic request = event.snapshot.value;
      if (request != null) {
        awaitingHelpRequestResponse = true;
        helpRequestMessage = request["requestdetails"].toString();
        helpRequestDistance = request["distance"].toString();
        helpRequestID = request["requestId"].toString();

        var location = request["location"];
        helpRequestLongitude = location["longitude"].toString();
        helpRequestLatitude = location["latitude"].toString();

        onHelpRequestReceived.add(null);
      }
    }
  }

  Future denyHelpRequest() async {
    awaitingHelpRequestResponse = false;
    helpRequestMessage = "";
    helpRequestDistance = "";
    var volunteerRef = database
        .child('/activevolunteerlist/')
        .child(UserInformationSingleton().getFirebaseUser()!.uid);
    await volunteerRef.update({"helpRequest": null});
    // get denied requests
    var deniedRequests = await volunteerRef.child('deniedRequests').get();
    // add the current request to the denied requests
    if (deniedRequests.value == null) {
      await volunteerRef.child('deniedRequests').set([helpRequestID]);
    } else {
      await volunteerRef
          .child('deniedRequests')
          .set("${deniedRequests.value},$helpRequestID");
    }
    helpRequestID = "";
  }

  Future acceptHelpRequest() async {
    currentHelpRequest = HelpRequest(
        message: helpRequestMessage,
        uid: helpRequestID,
        distance: helpRequestDistance,
        longitude: helpRequestLongitude,
        latitude: helpRequestLatitude);

    onHelpRequestAccepted.add(null);

    awaitingHelpRequestResponse = false;
    helpRequestMessage = "";
    helpRequestDistance = "";
    var volunteerRef = database
        .child('/activevolunteerlist/')
        .child(UserInformationSingleton().getFirebaseUser()!.uid);
    await volunteerRef.update({"helpRequest": null});
    // get accepted requests
    await volunteerRef.child('currentRequest').set([helpRequestID]);
    helpRequestID = "";
  }
}
