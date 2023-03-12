import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:disaster_relief_aid_flutter/view/VolunteerCall.view.dart';
import 'package:flutter/material.dart';

class HelpCallInProgressWrapper extends StatefulWidget {
  const HelpCallInProgressWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<HelpCallInProgressWrapper> createState() =>
      _HelpCallInProgressWrapperState();
}

class _HelpCallInProgressWrapperState extends State<HelpCallInProgressWrapper> {
  bool activeHelpRequest = VolunteeringSingleton().currentHelpRequest != null;
  // bool activeHelpRequest = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VolunteeringSingleton().onHelpRequestAcceptedStream.listen((event) {
      print("accepted help request");
      if (mounted) {
        setState(() {
          activeHelpRequest =
              VolunteeringSingleton().currentHelpRequest != null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: activeHelpRequest == true
          ? AppBar(
              title: TextButton(
                child: const Text("Help Request In Progress",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  // navigate to the help call in progress screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const VolunteerCallView()),
                  );
                },
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge,
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 3,
              backgroundColor: Colors.red,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VolunteerCallView()),
                      );
                    },
                    icon: const Icon(Icons.visibility))
              ],
            )
          : null,
      body: widget.child,
    );
  }
}
