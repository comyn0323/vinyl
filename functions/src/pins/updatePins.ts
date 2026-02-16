import { onRequest } from "firebase-functions/v2/https";
import { db } from "../init";

export const updatePins = onRequest(async (req, res) => {
    const { uid, pinned } = req.body || {};
    if (!uid || !Array.isArray(pinned)) {
        res.status(400).json({ error: "invalid_payload" });
        return;
    }

    if (pinned.length > 5) {
        res.status(400).json({ error: "pin_limit_reached" });
        return;
    }

    const uniquePinned = Array.from(new Set(pinned));
    if (uniquePinned.length !== pinned.length) {
        res.status(400).json({ error: "duplicate_pins" });
        return;
    }

    const friendChecks = await Promise.all(uniquePinned.map(async (friendUid) => {
        const doc = await db.collection("friends").doc(uid).collection("list").doc(friendUid).get();
        return doc.exists;
    }));

    if (friendChecks.some((exists) => !exists)) {
        res.status(400).json({ error: "not_friend" });
        return;
    }

    await db.collection("pins").doc(uid).set({
        pinned: uniquePinned,
        updatedAt: new Date()
    }, { merge: true });

    res.json({ success: true });
});
