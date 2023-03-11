import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {

// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");

// });

export const helpRequestMade = functions.database
  .ref("/requesthelplist/{userId}")
  .onCreate( async (snapshot, context) => {
    const userId = context.params.userId;
    const location = snapshot.child("location");
    const timestamp = snapshot.child("timestamp");

    const db = admin.database();

    // get activeVolunteerList
    const activeVolunteerList = await db.ref("/activevolunteerlist").get()
    activeVolunteerList.forEach((volunteer) => {
      const volunteerId = volunteer.key;
      const volunteerLocation = volunteer.child("location");
      const volunteerTimestamp = volunteer.child("timestamp");

      functions.logger.log("volunteerId", volunteerId);
      functions.logger.log("volunteerLocation", volunteerLocation);
      functions.logger.log("volunteerTimestamp", volunteerTimestamp);

      // check if volunteer is available
      
    });

    return null;
  });
