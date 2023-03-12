import 'package:disaster_relief_aid_flutter/singletons/Volunteering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HelpCallInProgressWrapper extends StatefulWidget {
  const HelpCallInProgressWrapper({required this.child, super.key});

  final Widget child;

  @override
  State<HelpCallInProgressWrapper> createState() =>
      _HelpCallInProgressWrapperState();
}

class _HelpCallInProgressWrapperState extends State<HelpCallInProgressWrapper> {
  bool activeHelpRequest = VolunteeringSingleton().currentHelpRequest != null;

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
                child: Text("Help Request In Progress"),
                onPressed: (){
                  
                },
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              elevation: 3,
              backgroundColor: Colors.red,
            )
          : null,
      body: widget.child,
    );
  }
}
