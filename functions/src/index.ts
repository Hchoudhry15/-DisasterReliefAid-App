import functions = require("firebase-functions");
import admin = require("firebase-admin");

import {getDistance} from "geolib";

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

    const helpRequest: any = snapshot.toJSON();
    // in the following format:
    // 'timestamp': DateTime.now().toString(),
    // 'requestdetails': requestDetails,
    // 'location': location.toJson(),

    const app = admin.initializeApp(functions.config().firebase);

    const deleteApp = () => app.delete().catch(() => null);

    app
      .database()
      .ref("/activevolunteerlist")
      .get()
      .then((activeVolunteerList) => {
        let bestVolunteer: any = null;
        let bestVolunteerDistance = 0;
        let bestVolunteerId = "";

        activeVolunteerList.forEach((volunteer) => {
          const volunteerId = volunteer.key;
          const volunteerData: any = volunteer.toJSON();
          if (volunteerData != null && volunteerId != null) {
            // check for a 'deniedRequests' field
            if (
              (volunteerData.deniedRequests == null ||
                !volunteerData.deniedRequests.includes(helpRequest.id)) &&
              volunteerData.helpRequest == null &&
              volunteerData.currentRequest == null
            ) {
              // check if the current helpRequest is in the deniedRequests list
              const volunteerLocation = volunteerData.location;
              if (volunteerLocation != null) {
                // get distance between volunteer and user
                const distance = getDistance(
                  {
                    latitude: helpRequest.location.latitude,
                    longitude: helpRequest.location.longitude,
                  },
                  {
                    latitude: volunteerLocation.latitude,
                    longitude: volunteerLocation.longitude,
                  }
                );
                functions.logger.debug("distance", distance);
                if (bestVolunteer == null || distance < bestVolunteerDistance) {
                  bestVolunteerDistance = distance;
                  bestVolunteer = volunteerData;
                  bestVolunteerId = volunteerId;
                }
              }
            }
          }
        });

        if (bestVolunteer != null) {
          // add/update the volunteer's child to have a helpRequest field
          app
            .database()
            .ref("/activevolunteerlist/" + bestVolunteerId)
            .update({
              helpRequest: {
                requestId: context.auth?.uid,
                distance: bestVolunteerDistance,
                ...helpRequest,
              },
            })
            .then(() => {
              deleteApp();
              return null;
            })
            .catch((err) => {
              functions.logger.error(err);
              deleteApp();
              return null;
            });
        }
        deleteApp();
        return null;
      })
      .catch((err) => {
        functions.logger.error(err);
        deleteApp();
        return null;
      });

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
