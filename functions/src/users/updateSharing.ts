import { onRequest } from "firebase-functions/v2/https";
import { db } from "../init";

export const updateSharing = onRequest(async (req, res) => {
    const { uid, sharingEnabled } = req.body || {};
    if (!uid || typeof sharingEnabled !== "boolean") {
        res.status(400).json({ error: "invalid_payload" });
        return;
    }

    await db.collection("users").doc(uid).set({
        sharingEnabled,
        updatedAt: new Date()
    }, { merge: true });

    res.json({ success: true });
});
