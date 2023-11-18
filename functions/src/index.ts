/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import * as sgMail from "@sendgrid/mail";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const sendEmail = functions.https.onCall(async (data, context) => {
  const db = admin.firestore();

  // SendGrid API-Schlüssel aus Firestore abrufen
  const sendgridDoc = await db
    .collection("Sendgrid")
    .doc("4ZDo3PafwXLKnTFDrMLk")
    .get();
  if (!sendgridDoc.exists) {
    throw new functions.https.HttpsError(
      "not-found",
      "SendGrid-Konfiguration nicht gefunden"
    );
  }
  const sendgridApiKey = sendgridDoc.data()?.apiKey;
  if (!sendgridApiKey) {
    throw new functions.https.HttpsError(
      "not-found",
      "SendGrid API-Schlüssel nicht gefunden"
    );
  }
  sgMail.setApiKey(sendgridApiKey);

  // E-Mail-Daten aus der Anfrage
  const { to, from, bcc, subject, html, attachment, filename } = data;

  const attachments = attachment
    ? [
        {
          content: attachment,
          filename: filename || "attachment.pdf", // Verwenden des übergebenen Dateinamens oder eines Standardnamens
          type: "application/pdf",
          disposition: "attachment",
        },
      ]
    : [];

  const msg: sgMail.MailDataRequired = {
    to,
    from,
    bcc,
    subject,
    html,
    attachments,
  };

  try {
    await sgMail.send(msg);
    return { success: true, message: "E-Mail erfolgreich gesendet" };
  } catch (error) {
    console.error("Fehler beim Senden der E-Mail:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Fehler beim Senden der E-Mail"
    );
  }
});

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
