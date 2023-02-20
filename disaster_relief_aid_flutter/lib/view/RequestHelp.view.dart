import 'package:flutter/material.dart';
import 'package:disaster_relief_aid_flutter/view/HelpCallInProgress.view.dart';

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
                Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                      ListTile(
                        leading: Icon(Icons.place),
                        title: Text('Your current location will be shared'),
                      ),
                    ])),
                TextFormField(
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
                ),
                ElevatedButton(
                    onPressed: () {
                      // do form validation
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();

                      // TODO: do something with the request details
                      // TODO: make the request to the backend
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => HelpCallInProgressView()));
                    },
                    child: const Text("Request Help"))
              ],
            )));
  }
}
