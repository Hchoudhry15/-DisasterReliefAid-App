import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RequestHelpView extends StatefulWidget {
  const RequestHelpView({super.key});

  @override
  State<RequestHelpView> createState() => _RequestHelpViewState();
}

class _RequestHelpViewState extends State<RequestHelpView> {
  String requestDetails = "";

  // make a key for the form
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Help"),
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                          ListTile(
                            leading: Icon(Icons.place),
                            title: Text('Your current location will be shared'),
                          ),
                        ]))),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Please describe your situation',
                      ),
                      maxLines: 5,
                      onChanged: (value) {
                        setState(() {
                          requestDetails = value;
                        });
                      },
                      onSaved: (newValue) {
                        if (newValue == null || newValue.isEmpty) {
                          return;
                        }
                        setState(() {
                          requestDetails = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Center(
                          child: Text(
                            "Request Help",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () async {
                        // do form validation
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();

                        // TODO: do something with the request details
                        // TODO: make the request to the backend
                        toProgress(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (c) => HelpCallInProgressView()));
                      },
                    ))
              ],
            )));
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
        Position location = await _determinePosition();
        print(location.toString());
        // print(location.altitude);
        await usernameEntry.update({'location': location.toJson()});
      } catch (e) {
        print("An error has occured");
        print(e);
      }
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => HelpCallInProgressView()));
  });
}

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

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
