import 'dart:async';

import 'package:cron/cron.dart';
import 'package:disaster_relief_aid_flutter/App.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/model/helprequest.model.dart';
import 'package:disaster_relief_aid_flutter/view/HelpRequestEnded.view.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';
import 'package:flutter/material.dart';
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

  StreamController onVolunteerDone = StreamController.broadcast();
  Stream get onVolunteerDoneStream => onVolunteerDone.stream;

  bool awaitingHelpRequestResponse = false;
  String helpRequestMessage = "";
  String helpRequestDistance = "";
  String helpRequestID = "";
  String helpRequestLongitude = "";
  String helpRequestLatitude = "";

  bool volunteeringDone = false;
  bool volunteeringCompleted = false;

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
    if (onAddedListener != null) {
      await onAddedListener!.cancel();
    }
    if (onUpdatedListener != null) {
      await onUpdatedListener!.cancel();
    }

    volunteeringCompleted = false;
    volunteeringDone = false;

    await attemptVolunteering(first: true);
    currentJob = cron.schedule(Schedule.parse("*/20 * * * * *"), () async {
      await attemptVolunteering();
      // print("Update Volunteer location!");
    });

    User? user = UserInformationSingleton().getFirebaseUser();
    final userRef = database.child('/activevolunteerlist/');
    final userEntry = userRef.child(user!.uid);

    // create a subscription to wait for the data to be updated (or added)
    onAddedListener = userEntry.onChildAdded.listen(onAddedOrUpdated);
    onUpdatedListener = userEntry.onChildChanged.listen(onAddedOrUpdated);
  }

  Future attemptVolunteering({bool first = false}) async {
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user != null) {
      await addActiveVolunteer(user.uid, first: first);
    } else {
      print("The user is currently null");
    }
  }

  Future stopVolunteering() async {
    User? user = UserInformationSingleton().getFirebaseUser();
    if (currentJob != null) {
      await currentJob!.cancel();
      currentJob = null;
    }
    if (onAddedListener != null) {
      await onAddedListener!.cancel();
    }
    if (onUpdatedListener != null) {
      await onUpdatedListener!.cancel();
    }
    if (user != null) {
      await removeActiveVolunteer(user.uid);
    }
  }

  get isCurrentlyVolunteering {
    return currentJob != null;
  }

  Future addActiveVolunteer(String uID, {bool first = false}) async {
    final userRef = database.child('/activevolunteerlist/');
    var userID = uID;
    final userEntry = userRef.child(userID);

    // check if exists
    if (first) {
      var exists = await userEntry.once();
      if (exists.snapshot.exists) {
        // delete
        await userEntry.remove();
      }
    }

    try {
      Position location = await Location.determinePosition();
      await userEntry.update({
        'timestamp': DateTime.now().toString(),
        'location': location.toJson()
      });

      if (currentHelpRequest != null) {
        var helpRequestRef =
            database.child('/requesthelplist/').child(currentHelpRequest!.uid);

        await helpRequestRef.update({"volunteerLocation": location.toJson()});
      }
    } catch (e) {
      print("An error has occured");
      print(e);
    }
  }

  Future removeActiveVolunteer(String uID) async {
    final userRef = database.child('/activevolunteerlist/');
    var userID = uID;
    final userEntry = userRef.child(userID);
    try {
      if (userEntry != null) {
        await userEntry.remove();
      }
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
    } else if (event.snapshot.key == "endNotification") {
      String notif = event.snapshot.value.toString();
      bool isCompleted = notif == "COMPLETED";
      currentHelpRequest = null;

      volunteeringDone = true;
      onVolunteerDone.add(null);
      onHelpRequestAccepted.add(null);
      stopVolunteering();

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => HelpRequestEndedView(
            wasMe: false,
            isCompleted: isCompleted,
          ),
        ),
      );
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
    // set the current help request

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
    await volunteerRef.child('currentRequest').set(helpRequestID);

    // update the help request to show that it has been accepted (and by who)
    var helpRequestRef =
        database.child('/requesthelplist/').child(helpRequestID);

    // get location
    Position location = await Location.determinePosition();

    await helpRequestRef.update({
      "status": "accepted",
      "volunteerID": UserInformationSingleton().getFirebaseUser()!.uid,
      "volunteerName":
          UserInformationSingleton().getRealtimeUserInfo()!.fname ?? "Unknown",
      "volunteerLocation": location.toJson()
    });

    helpRequestID = "";
  }

  Future cancelHelpRequest() async {
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    // update the user's help request to show that it has been cancelled
    var helpRequestRef =
        database.child('/requesthelplist/').child(currentHelpRequest!.uid);

    await helpRequestRef.update({
      "endNotification": "CANCELLED",
    });

    // // delete active volunteer
    // await removeActiveVolunteer(user.uid);

    currentHelpRequest = null;
    volunteeringDone = true;
    helpRequestID = "";
    onVolunteerDone.add(null);
    onHelpRequestAccepted.add(null);
    await stopVolunteering();
  }

  Future markHelpRequestAsCompleted() async {
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    // update the user's help request to show that it has been cancelled
    var helpRequestRef =
        database.child('/requesthelplist/').child(currentHelpRequest!.uid);

    await helpRequestRef.update({
      "endNotification": "COMPLETED",
    });

    // // delete active volunteer
    // await removeActiveVolunteer(user.uid);

    currentHelpRequest = null;
    volunteeringDone = true;
    helpRequestID = "";
    onVolunteerDone.add(null);
    onHelpRequestAccepted.add(null);
    await stopVolunteering();
  }
}
