import 'dart:async';
import 'package:cron/cron.dart';
import 'package:disaster_relief_aid_flutter/App.dart';
import 'package:disaster_relief_aid_flutter/view/HelpRequestEnded.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  StreamController helpRequestUpdated = StreamController.broadcast();
  Stream get onhelpRequestUpdated => helpRequestUpdated.stream;

  // pertaining to the current help request

  HelpRequestStatus _currentHelpRequestStatus = HelpRequestStatus.NONE;
  HelpRequestStatus get currentHelpRequestStatus => _currentHelpRequestStatus;

  /// The ID of the volunteer that is currently helping the user.
  String _volunteerID = "";
  String get volunteerID => _volunteerID;

  String _volunteerName = "";
  String get volunteerName => _volunteerName;

  String _volunteerLatitude = "";
  String get volunteerLatitude => _volunteerLatitude;

  String _volunteerLongitude = "";
  String get volunteerLongitude => _volunteerLongitude;

  Position? _myLocation = null;
  Position? get myLocation => _myLocation;

  double _volunteerDistance = 0.0;
  double get volunteerDistance => _volunteerDistance;

  String _volunteerDistanceUnit = "m";
  String get volunteerDistanceUnit => _volunteerDistanceUnit;

  /// Starts a new help request. This can only be called when a help request has not been started.
  Future startHelpRequest(BuildContext context, String requestDetails) async {
    // check if help request is already active
    if (currentHelpRequestStatus != HelpRequestStatus.NONE) {
      throw Exception("Help request already active");
    }
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      throw Exception("User is not logged in");
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
      _myLocation = await Location.determinePosition();

      await userEntry.set({
        'timestamp': DateTime.now().toString(),
        'requestdetails': requestDetails,
        'location': _myLocation!.toJson(),
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
        _myLocation = await Location.determinePosition();
        await userEntry.update({'location': _myLocation!.toJson()});
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

  void cancelHelpRequest() {
    // check if help request is already active
    if ([
      HelpRequestStatus.NONE,
      HelpRequestStatus.COMPLETED,
      HelpRequestStatus.CANCELLED
    ].contains(currentHelpRequestStatus)) {
      throw Exception("No help request is active.");
    }

    // get the database reference
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    cancelAllJobs();

    // update the volunteer's entry
    final volRef = database.child('/activevolunteerlist/');
    final volEntry = volRef.child(_volunteerID);
    volEntry.update({'endNotification': "CANCELLED"});

    final userRef = database.child('/requesthelplist/');
    var userID = user.uid;
    final userEntry = userRef.child(userID);

    // set status of help request to cancelled
    _currentHelpRequestStatus = HelpRequestStatus.NONE;

    // remove the entry from the database
    userEntry.remove();
  }

  void markHelpRequestAsCompleted() {
    // check if help request is already active
    if ([
      HelpRequestStatus.NONE,
      HelpRequestStatus.COMPLETED,
      HelpRequestStatus.CANCELLED
    ].contains(currentHelpRequestStatus)) {
      throw Exception("No help request is active.");
    }

    // get the database reference
    User? user = UserInformationSingleton().getFirebaseUser();
    if (user == null) {
      throw Exception("No user is logged in.");
    }

    cancelAllJobs();

    // update the volunteer's entry
    final volRef = database.child('/activevolunteerlist/');
    final volEntry = volRef.child(_volunteerID);
    volEntry.update({'endNotification': "COMPLETED"});

    final userRef = database.child('/requesthelplist/');
    var userID = user.uid;
    final userEntry = userRef.child(userID);

    // set status of help request to cancelled
    _currentHelpRequestStatus = HelpRequestStatus.NONE;

    // remove the entry from the database
    userEntry.remove();
  }

  void cancelAllJobs() {
    if (currentJob != null) {
      currentJob!.cancel();
    }
    if (onAddedListener != null) {
      onAddedListener!.cancel();
    }
    if (onUpdatedListener != null) {
      onUpdatedListener!.cancel();
    }
  }

  /// This function is called when the Volunteer's entry is updated
  void onAddedOrUpdated(DatabaseEvent event) {
    // check if a user's request has been sent here.
    // print(event.snapshot.key);
    // TODO: WATCH FOR UPDATES FROM THE VOLUNTEER SIDE
    if (event.snapshot.key == "volunteerID") {
      // the volunteer has accepted the request
      _currentHelpRequestStatus = HelpRequestStatus.ACCEPTED;
      _volunteerID = event.snapshot.value.toString();
      helpRequestUpdated.add(null);
    } else if (event.snapshot.key == "volunteerName") {
      _volunteerName = event.snapshot.value.toString();
      helpRequestUpdated.add(null);
    } else if (event.snapshot.key == "volunteerLocation") {
      dynamic location = event.snapshot.value;
      if (location != null) {
        _volunteerLongitude = location['longitude'].toString();
        _volunteerLatitude = location['latitude'].toString();

        // calculate distance between the user and the volunteer
        _volunteerDistance = Geolocator.distanceBetween(
            double.parse(_volunteerLatitude),
            double.parse(_volunteerLongitude),
            _myLocation!.latitude,
            _myLocation!.longitude);

        if (volunteerDistance > 1000) {
          _volunteerDistance = _volunteerDistance / 1000;
          _volunteerDistanceUnit = "km";
        } else {
          _volunteerDistanceUnit = "m";
        }

        helpRequestUpdated.add(null);
      }
    } else if (event.snapshot.key == "endNotification") {
      String notif = event.snapshot.value.toString();
      bool isCompleted = notif == "COMPLETED";

      // remove the entry from the database
      final userRef = database.child('/requesthelplist/');
      User? user = UserInformationSingleton().getFirebaseUser();
      if (user == null) {
        throw Exception("No user is logged in.");
      }
      var userID = user.uid;
      final userEntry = userRef.child(userID);
      userEntry.remove();

      cancelAllJobs();

      _volunteerID = "";
      _volunteerName = "";
      _volunteerLongitude = "";
      _volunteerLatitude = "";
      _volunteerDistance = 0;
      _volunteerDistanceUnit = "m";
      _currentHelpRequestStatus = HelpRequestStatus.NONE;

      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => HelpRequestEndedView(
            wasMe: false,
            isCompleted: isCompleted,
          ),
        ),
      );
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
