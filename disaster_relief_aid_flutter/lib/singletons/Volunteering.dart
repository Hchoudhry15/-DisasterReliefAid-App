import 'package:cron/cron.dart';

class VolunteeringSingleton {
  static final VolunteeringSingleton _volunteeringSingleton =
      VolunteeringSingleton._internal();

  factory VolunteeringSingleton() {
    return _volunteeringSingleton;
  }

  VolunteeringSingleton._internal() {
    cron = Cron();
  }

  Future startVolunteering() async {
    if (currentJob != null) {
      await currentJob!.cancel();
    }
    currentJob = cron.schedule(Schedule.parse("*/20 * * * * *"), () async {
      // do something
      print("Update Volunteer location!");
    });
  }

  Future stopVolunteering() async {
    if (currentJob != null) {
      await currentJob!.cancel();
    }
  }

  late Cron cron;
  ScheduledTask? currentJob;
}
