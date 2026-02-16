import { onRequest } from "firebase-functions/v2/https";
import { db } from "../init";

export const respondRequest = onRequest(async (req, res) => {
    const { requestId, action } = req.body || {};
    if (!requestId || !action) {
        res.status(400).json({ error: "missing_payload" });
        return;
    }

    const requestRef = db.collection("friendRequests").doc(requestId);

    try {
        await db.runTransaction(async (tx) => {
            const requestSnap = await tx.get(requestRef);
            if (!requestSnap.exists) {
                throw new Error("request_not_found");
            }

            const data = requestSnap.data();
            if (!data || data.status !== "pending") {
                throw new Error("request_not_pending");
            }

            const fromUid = data.fromUid as string;
            const toUid = data.toUid as string;

            if (action === "accepted") {
                const fromQuery = db.collection("friends").doc(fromUid).collection("list");
                const toQuery = db.collection("friends").doc(toUid).collection("list");
                const fromSnapshot = await tx.get(fromQuery);
                const toSnapshot = await tx.get(toQuery);

                if (fromSnapshot.size >= 10 || toSnapshot.size >= 10) {
                    throw new Error("friend_limit_reached");
                }

                tx.set(db.collection("friends").doc(fromUid).collection("list").doc(toUid), {
                    createdAt: new Date()
                }, { merge: true });
                tx.set(db.collection("friends").doc(toUid).collection("list").doc(fromUid), {
                    createdAt: new Date()
                }, { merge: true });
                tx.update(requestRef, { status: "accepted" });
            } else if (action === "rejected") {
                tx.update(requestRef, { status: "rejected" });
            } else if (action === "canceled") {
                tx.update(requestRef, { status: "canceled" });
            } else {
                throw new Error("invalid_action");
            }
        });

        res.json({ success: true });
    } catch (error) {
        res.status(400).json({ error: String(error) });
    }
});
