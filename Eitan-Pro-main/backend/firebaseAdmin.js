const admin = require("firebase-admin");
const path = require("path");

// Use serviceAccountKey.json if it exists, otherwise use environment variables (for cloud deployment)
const serviceAccountPath = path.join(__dirname, "serviceAccountKey.json");

try {
    const serviceAccount = require(serviceAccountPath);
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
    });
    console.log("✔️ Firebase Admin initialized with serviceAccountKey.json");
} catch (error) {
    console.error("❌ Error loading serviceAccountKey.json:", error.message);
    if (process.env.FIREBASE_PROJECT_ID) {
        admin.initializeApp({
            credential: admin.credential.applicationDefault(),
            projectId: process.env.FIREBASE_PROJECT_ID
        });
        console.log("✔️ Firebase Admin initialized with applicationDefault");
    } else {
        console.warn("⚠️ Warning: serviceAccountKey.json not found and FIREBASE_PROJECT_ID not set.");
        console.warn("⚠️ Firebase features will not work until you provide the credentials.");

        // Fallback for local development so server doesn't crash immediately on import
        // (though Firestore calls will fail)
        if (!admin.apps.length) {
            admin.initializeApp();
        }
    }
}

const db = admin.firestore();

module.exports = { db, admin };
