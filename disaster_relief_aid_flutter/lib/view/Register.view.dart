import 'package:disaster_relief_aid_flutter/component/DatePicker.component.dart';
import 'package:disaster_relief_aid_flutter/component/FormDropDown.component.dart';
import 'package:disaster_relief_aid_flutter/component/MultiSelectDropDown.component.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import "package:intl/intl.dart";

import '../DRA.config.dart';
import '../model/user.model.dart';
import 'Main.view.dart';

class CreateProfileView extends StatefulWidget {
  const CreateProfileView({super.key});

  @override
  State<CreateProfileView> createState() => _CreateProfileViewState();
}

class _CreateProfileViewState extends State<CreateProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Profile"),
        ),
        body: const SingleChildScrollView(child: CreateProfileForm()));
  }
}

class CreateProfileForm extends StatefulWidget {
  const CreateProfileForm({super.key});

  @override
  State<CreateProfileForm> createState() => _CreateProfileFormState();
}

class _CreateProfileFormState extends State<CreateProfileForm> {
  final database = FirebaseDatabase.instance.ref();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User user = User();
    final userRef = database.child('/users');

    return Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: FormDropDown(
                            items: Config.languages,
                            labelText: "Language",
                            initialValue: Config.languages[0],
                            onSaved: (value) {
                              user.language = value;
                            }))
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        hintText: "Enter your first name",
                      ),
                      autofillHints: const [AutofillHints.givenName],
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          user.fname = value;
                        }
                      },
                    ))
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: DatePicker(
                      label: "Birthdate",
                      onChanged: (value) {
                        user.birthdate = value;
                      },
                      required: true,
                    ))
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 32),
                  child: Row(children: [
                    Expanded(
                        child: CustomMultiselectDropDown(
                      listOFStrings: Config.vulnerabilities.toList(),
                      onSelected: (List<dynamic> values) {
                        user.vulnerabilities =
                            values.map((e) => e as String).toList();
                      },
                      labelText: "Vulnerabilities",
                      hintText: "Select your vulnerabilities",
                    ))
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // process data woo!
                            //print form data
                            _formKey.currentState!.save();
                            try {
                              await userRef.set({
                                'uID': 0, // Placeholder for UserID
                                'description': user.fname,
                                'language': user.language,
                                'birthdate': user.birthdate,
                                'vulnerabilities': user.vulnerabilities
                              });
                              print(user);
                            } catch (e) {
                              print("An error has occured");
                            }
                            // navigate to home page
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainView()));
                          }
                        },
                        child: const Text("Submit"))
                  ],
                )
              ],
            ))));
  }
}
