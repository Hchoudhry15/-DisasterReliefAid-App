import 'dart:async';
import 'package:cron/cron.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'UserInformation.dart';

class HelpRequestSingleton {
  static final HelpRequestSingleton _singleton =
      HelpRequestSingleton._internal();

  factory HelpRequestSingleton() {
    return _singleton;
  }

  HelpRequestSingleton._internal() {
    cron = Cron();
    database = FirebaseDatabase.instance.ref();
    onUpdatedListener = null;
    onAddedListener = null;
  }

  late Cron cron;
  ScheduledTask? currentJob;
  late DatabaseReference database;

  StreamSubscription<DatabaseEvent>? onAddedListener;
  StreamSubscription<DatabaseEvent>? onUpdatedListener;

  // pertaining to the current help request

  HelpRequestStatus _currentHelpRequestStatus = HelpRequestStatus.NONE;
  HelpRequestStatus get currentHelpRequestStatus => _currentHelpRequestStatus;

  /// The ID of the volunteer that is currently helping the user.
  String _volunteerID = "";
  String get volunteerID => _volunteerID;

  /// Starts a new help request. This can only be called when a help request has not been started.
  Future startHelpRequest(BuildContext context, String requestDetails) async {
    // check if help request is already active
    if (currentHelpRequestStatus != HelpRequestStatus.NONE) {
      return;
    }
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      return;
    }

    // get the database reference
    final userRef = database.child('/requesthelplist/');
    var userID = user.uid;
    final userEntry = userRef.child(userID);

    // check if an entry already exists
    // if it does, delete
    var snapshot = await userEntry.get();
    if (snapshot.exists) {
      await userEntry.remove();
    }

    // add a new entry
    try {
      Position location = await Location.determinePosition();

      await userEntry.set({
        'timestamp': DateTime.now().toString(),
        'requestdetails': requestDetails,
        'location': location.toJson(),
      });
    } catch (e) {
      print("HelpRequestSingleton: An error has occured");
      print(e);
      throw Exception("Could not create new help request, Please try again.");
    }

    // set the status to active
    _currentHelpRequestStatus = HelpRequestStatus.AWAITING_RESPONSE;

    // cancel the current job
    if (currentJob != null) {
      currentJob!.cancel();
    }
    // start a new job
    currentJob = cron.schedule(Schedule.parse("*/20 * * * * *"), () async {
      // update the location
      try {
        Position location = await Location.determinePosition();
        await userEntry.update({'location': location.toJson()});
      } catch (e) {
        print("HelpRequestSingleton: An error has occured");
        print(e);
      }
    });

    // add a listener to the database
    onAddedListener = userEntry.onChildAdded.listen(onAddedOrUpdated);
    onUpdatedListener = userEntry.onChildChanged.listen(onAddedOrUpdated);
  }

  // Future addUserRequestHelpList(User user) async {
  //   final userRef = database.child('/requesthelplist/');
  //   var userID = user.uid;
  //   final userEntry = userRef.child(userID);
  //   try {
  //     Position location = await Location.determinePosition();

  //     await userEntry.set({
  //       'timestamp': DateTime.now().toString(),
  //       'requestdetails': requestDetails,
  //       'location': location.toJson(),
  //     });
  //   } catch (e) {
  //     print("RequestHelpList: An error has occured");
  //     print(e);
  //   }
  // }

  void cancelHelpRequest() {}

  void markHelpRequestAsCompleted() {}

  /// This function is called when the Volunteer's entry is updated
  void onAddedOrUpdated(DatabaseEvent event) {
    // check if a user's request has been sent here.
    print(event.snapshot.key);
    // TODO: WATCH FOR UPDATES FROM THE VOLUNTEER SIDE
    if (event.snapshot.key == "volunteerID") {
      // the volunteer has accepted the request
      _currentHelpRequestStatus = HelpRequestStatus.ACCEPTED;
      _volunteerID = event.snapshot.value.toString();
    }
    //   if (event.snapshot.key == "helpRequest") {
    //     dynamic request = event.snapshot.value;
    //     if (request != null) {
    //       awaitingHelpRequestResponse = true;
    //       helpRequestMessage = request["requestdetails"].toString();
    //       helpRequestDistance = request["distance"].toString();
    //       helpRequestID = request["requestId"].toString();

    //       var location = request["location"];
    //       helpRequestLongitude = location["longitude"].toString();
    //       helpRequestLatitude = location["latitude"].toString();

    //       onHelpRequestReceived.add(null);
    //     }
    //   }
  }
}

enum HelpRequestStatus {
  NONE,
  AWAITING_RESPONSE,
  ACCEPTED,
  COMPLETED,
  CANCELLED,
}
