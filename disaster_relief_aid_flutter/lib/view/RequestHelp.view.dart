import 'package:disaster_relief_aid_flutter/component/HelpCallInProgressWrapper.dart';
import 'package:disaster_relief_aid_flutter/singletons/HelpRequest.dart';
import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:disaster_relief_aid_flutter/Location.dart';
import 'package:disaster_relief_aid_flutter/singletons/UserInformation.dart';

class RequestHelpView extends StatefulWidget {
  const RequestHelpView({super.key});

  @override
  State<RequestHelpView> createState() => _RequestHelpViewState();
}

class _RequestHelpViewState extends State<RequestHelpView> {
  final database = FirebaseDatabase.instance.ref();
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
                        User? user =
                            UserInformationSingleton().getFirebaseUser();
                        if (user != null) {
                          try {
                            // await addUserRequestHelpList(user);
                            await HelpRequestSingleton()
                                .startHelpRequest(context, requestDetails);
                            // ignore: use_build_context_synchronously
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (c) =>
                                        const HelpCallInProgressWrapper(
                                            child: HelpCallInProgressView())));
                          } catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(err.toString())));
                          }
                        } else {
                          print("USER IS NULL!!!!!!");
                          // show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'You are not currently logged in!')));
                        }
                      },
                    ))
              ],
            )));
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
}
