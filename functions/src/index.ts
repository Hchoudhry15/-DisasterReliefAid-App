import functions = require("firebase-functions");
import admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);
import { getDistance } from "geolib";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {

// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");

// });

export const helpRequestMade = functions.database
  .ref("/requesthelplist/{userId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const location = snapshot.child("location");
    const timestamp = snapshot.child("timestamp");

    const db = admin.database();

    // get activeVolunteerList
    const activeVolunteerList = await db.ref("/activevolunteerlist").get();
    activeVolunteerList.forEach((volunteer) => {
      const volunteerId = volunteer.key;
      const volunteerLocation = volunteer.child("location");
      const volunteerTimestamp = volunteer.child("timestamp");
      // check if volunteer is available

      // get distance between volunteer and user
      const distance = getDistance(
        {
          latitude: location.child("latitude").val(),
          longitude: location.child("longitude").val(),
        },
        {
          latitude: volunteerLocation.child("latitude").val(),
          longitude: volunteerLocation.child("longitude").val(),
        }
      );
      functions.logger.debug("distance", distance);
    });

    return null;
  });
