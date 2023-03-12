import functions = require("firebase-functions");
// import admin = require("firebase-admin");

// import {getDistance} from "geolib";

// // Start writing functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {

// //   functions.logger.info("Hello logs!", {structuredData: true});
// //   response.send("Hello from Firebase!");

// });

export const helpRequestMade = functions.database
  .ref("/requesthelplist/{userId}")
  .onCreate((snapshot, context) => {
    // const ref = snapshot.ref;

    functions.logger.log(JSON.stringify(snapshot.toJSON()));
    return 0;

    // const app = admin.initializeApp(functions.config().firebase);

    // const deleteApp = () => app.delete().catch(() => null);

    // app
    //   .database()
    //   .ref(ref)
    //   .get()
    //   .then((snapshot) => {
    //     functions.logger.log(JSON.stringify(snapshot.toJSON()));
    //     deleteApp();
    //     return null;
    //   })
    //   .catch((err) => {
    //     functions.logger.error(err);
    //     deleteApp();
    //     return null;
    //   });

    // const userId = context.params.userId;
    // const location = snapshot.child("location");
    // const timestamp = snapshot.child("timestamp");

    // functions.logger.log(snapshot.val());

    // const latitude = location.child("latitude").val();
    // const longitude = location.child("longitude").val();

    // functions.logger.log("latitude", latitude);
    // functions.logger.log("longitude", longitude);

    // admin.initializeApp(functions.config().firebase);

    // const db = admin.database();

    // // get activeVolunteerList
    // const activeVolunteerList = await db.ref("/activevolunteerlist").get();
    // activeVolunteerList.forEach((volunteer) => {
    //   // const volunteerId = volunteer.key;
    //   // const volunteerLocation = volunteer.child("location");
    //   // // const volunteerTimestamp = volunteer.child("timestamp");
    //   // // check if volunteer is available

    //   // // get distance between volunteer and user
    //   // const distance = getDistance(
    //   //   {
    //   //     latitude: latitude,
    //   //     longitude: longitude,
    //   //   },
    //   //   {
    //   //     latitude: volunteerLocation.child("latitude").val(),
    //   //     longitude: volunteerLocation.child("longitude").val(),
    //   //   }
    //   // );
    //   // functions.logger.debug("distance", distance);
    // });
  });
