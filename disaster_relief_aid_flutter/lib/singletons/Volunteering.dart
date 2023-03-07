import 'package:cron/cron.dart';

class VolunteeringSingleton {
  static final VolunteeringSingleton _volunteeringSingleton =
      VolunteeringSingleton._internal();

  factory VolunteeringSingleton() {
    return _volunteeringSingleton;
  }

  VolunteeringSingleton._internal() {
    var cron = Cron();
    cron.schedule(Schedule.parse("* * * * *"), () async {
      print(isCurrentlyVolunteering);
      if (isCurrentlyVolunteering) {
        // get volunteer's current location and send to database
      }
    });
  }

  bool isCurrentlyVolunteering = false;
}
