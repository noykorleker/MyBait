import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();
const fcm = admin.messaging();

exports.checkHealth = functions.https.onCall(async (data, context) => {
  return "The function is online";
});

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const token = data.token;

  try {
    const payload = {
      token: token,
      notification: {
        title: title,
        body: body,
      },
      data: {
        body: body,
      },
    };

    return fcm.send(payload).then((response) => {
      return {success: true, response: "Succefully sent message: " + response};
    }).catch((error) => {
      return {error: error};
    });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "error:" +error);
  }
});

exports.sendGroupNotify = functions.https.onCall(async (data, context) => {
  const title = data.title;
  const body = data.body;
  const tokens = data.tokens;

  try {
    const payload = {
      tokens: tokens,
      notification: {
        title: title,
        body: body,
      },
      data: {
        body: body,
      },
    };

    return admin.messaging().sendMulticast(payload)
      .then((response) => {
        const successCount = response.successCount;
        return {
          success: true,
          response: `Successfully sent ${successCount} messages.`,
        };
      })
      .catch((error) => {
        return {
          success: false,
          error: error,
        };
      });
  } catch (error) {
    throw new functions.https.HttpsError("invalid-argument", "Error: " + error);
  }
});
