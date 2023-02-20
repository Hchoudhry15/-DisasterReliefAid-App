import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RequestHelpView extends StatelessWidget {
  const RequestHelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Help"),
        ),
        body: Column(
          children: [
            // const Text("test"),
            // const Text("testt"),
            ElevatedButton(
                onPressed: toProgress(context),
                child: const Text("Check Status"))
          ],
        ));
  }
}

toProgress(context) {
  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    final database = FirebaseDatabase.instance.ref();
    if (user != null) {
      String userID = user.uid;
      final userRef = database.child('/users/');
      final usernameEntry = userRef.child(userID);
      try {
        await usernameEntry.update({
          'location': _determinePosition(),
        });
      } catch (e) {
        print("An error has occured");
        print(e);
      }
    }
  });
  Navigator.push(
      context, MaterialPageRoute(builder: (c) => HelpCallInProgressView()));
}

Position _currentPosition;
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  _currentPosition = _determinePosition();
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
