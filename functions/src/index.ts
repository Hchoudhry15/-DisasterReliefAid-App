import * as functions from "firebase-functions";

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
    const userId = context.params.userId;
    const location = snapshot.child("location");
    return null;
  });
