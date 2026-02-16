import { onRequest } from "firebase-functions/v2/https";
import { db } from "../init";

export const sendRequest = onRequest(async (req, res) => {
    const { fromUid, toUid } = req.body || {};
    if (!fromUid || !toUid) {
        res.status(400).json({ error: "missing_payload" });
        return;
    }

    if (fromUid === toUid) {
        res.status(400).json({ error: "cannot_request_self" });
        return;
    }

    const existingFriend = await db.collection("friends").doc(fromUid).collection("list").doc(toUid).get();
    if (existingFriend.exists) {
        res.status(409).json({ error: "already_friends" });
        return;
    }

    const requestId = `${fromUid}_${toUid}`;
    const requestRef = db.collection("friendRequests").doc(requestId);
    const existingRequest = await requestRef.get();
    if (existingRequest.exists) {
        res.status(409).json({ error: "request_exists" });
        return;
    }

    await requestRef.set({
        fromUid,
        toUid,
        status: "pending",
        createdAt: new Date()
    });

    res.json({ success: true, requestId });
});
