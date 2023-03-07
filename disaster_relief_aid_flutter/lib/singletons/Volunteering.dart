import 'package:cron/cron.dart';

class VolunteeringSingleton {
  static final VolunteeringSingleton _volunteeringSingleton =
      VolunteeringSingleton._internal();

  factory VolunteeringSingleton() {
    return _volunteeringSingleton;
  }

  VolunteeringSingleton._internal() {
    var cron = Cron();
    cron.schedule(Schedule.parse("*/2 * * * *"), () async {
      if (isCurrentlyVolunteering) {
        // get volunteer's current location and send to database
      }
    });
  }

  bool isCurrentlyVolunteering = false;
}
