const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();

// Fires whenever the admin's upload screen writes a new content_items
// document. Publishes to the "new_content" topic every signed-in device
// subscribes to on sign-in (see lib/services/push_notification_service.dart) —
// no per-device token management needed here.
exports.notifyOnNewContent = onDocumentCreated(
    "content_items/{contentId}",
    async (event) => {
      const data = event.data?.data();
      if (!data) return;

      const message = {
        topic: "new_content",
        notification: {
          title: "New on REVA",
          body: data.title || "New content is now available.",
        },
        data: {
          contentId: event.params.contentId,
        },
      };

      await getMessaging().send(message);
    },
);
