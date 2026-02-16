import { onSchedule } from "firebase-functions/v2/scheduler";
import { db } from "../init";
import { getCurrentlyPlaying } from "../spotify/getCurrentlyPlaying";
import { hasPresenceChanged } from "./diffTrack";
import { updatePresence } from "./updatePresence";
import { sendLiveActivityPush } from "../push/sendLiveActivityPush";

const CONCURRENCY = 8;

export const pollPresence = onSchedule("every 1 minutes", async () => {
    const snapshot = await db.collection("users").where("sharingEnabled", "==", true).get();
    const users = snapshot.docs.map((doc) => ({
        uid: doc.id,
        lastTrackId: doc.get("lastTrackId") as string | null
    }));

    const batches: Array<Promise<void>> = [];

    for (const user of users) {
        const task = (async () => {
            try {
                const current = await getCurrentlyPlaying(user.uid);

                if (hasPresenceChanged(user.lastTrackId, current)) {
                    await db.collection("users").doc(user.uid).set({
                        lastTrackId: current?.trackId ?? null,
                        updatedAt: new Date()
                    }, { merge: true });

                    await updatePresence(user.uid, current);

                    if (current) {
                        const viewers = await db.collection("pins")
                            .where("pinned", "array-contains", user.uid)
                            .get();

                        const tokenSnaps = await Promise.all(
                            viewers.docs.map((doc) => db.collection("liveActivityTokens").doc(doc.id).get())
                        );

                        const pushTasks = tokenSnaps
                            .filter((snap) => snap.exists)
                            .map((snap) => snap.get("pushToken") as string)
                            .filter((token) => Boolean(token))
                            .map((token) => sendLiveActivityPush(token, {
                                trackName: current.trackName,
                                artistName: current.artistName,
                                albumArtUrl: current.albumArtUrl,
                                timestamp: Date.now()
                            }));

                        await Promise.allSettled(pushTasks);
                    }
                }
            } catch {
                await updatePresence(user.uid, null);
            }
        })();

        batches.push(task);
        if (batches.length >= CONCURRENCY) {
            await Promise.allSettled(batches);
            batches.length = 0;
        }
    }

    if (batches.length > 0) {
        await Promise.allSettled(batches);
    }
});
