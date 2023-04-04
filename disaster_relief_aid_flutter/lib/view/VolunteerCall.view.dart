import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:disaster_relief_aid_flutter/view/HelpRequestEnded.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maps_launcher/maps_launcher.dart';

class VolunteerCallView extends StatefulWidget {
  const VolunteerCallView({super.key});

  @override
  State<VolunteerCallView> createState() => _VolunteerCallViewState();
}

class _VolunteerCallViewState extends State<VolunteerCallView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Call"),
      ),
      body: Column(
        children: [
          Card(
            child: ListTile(
              title: const Text("Help Request Message"),
              subtitle:
                  Text(VolunteeringSingleton().currentHelpRequest!.message),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            // confirm with dialog
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Confirm Cancel"),
                                      content: const Text(
                                          "Are you sure you want to cancel the request?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Cancelling Request...")));
                                              try {
                                                VolunteeringSingleton()
                                                    .cancelHelpRequest();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HelpRequestEndedView(
                                                              wasMe: true,
                                                            )));
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            e.toString())));
                                              }
                                            },
                                            child: const Text("Yes"))
                                      ],
                                    ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                          ),
                          icon: const Icon(Icons.cancel),
                          label: const Text("Cancel Request"))),
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () {
                            // confirm with dialog
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Confirm Complete"),
                                      content: const Text(
                                          "Are you sure you want to mark the request as complete?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("No")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          "Marking Request as Complete...")));
                                              try {
                                                VolunteeringSingleton()
                                                    .markHelpRequestAsCompleted();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HelpRequestEndedView(
                                                              wasMe: true,
                                                              isCompleted: true,
                                                            )));
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            e.toString())));
                                              }
                                            },
                                            child: const Text("Yes"))
                                      ],
                                    ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                          ),
                          icon: const Icon(Icons.check),
                          label: const Text("Mark Request as Complete")))
                ],
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.map),
          label: const Text("Navigate"),
          onPressed: () {
            var latitude = VolunteeringSingleton().currentHelpRequest!.latitude;
            var longitude =
                VolunteeringSingleton().currentHelpRequest!.longitude;

            double? parsedLatitude = double.tryParse(latitude);
            double? parsedLongitude = double.tryParse(longitude);

            if (parsedLatitude == null || parsedLongitude == null) {
              // print("Launching query");
              MapsLauncher.launchQuery("$latitude, $longitude");
            } else {
              // print("Launching coordinates: $parsedLatitude, $parsedLongitude");
              MapsLauncher.launchCoordinates(parsedLatitude, parsedLongitude);
            }
          }),
    );
  }
}
