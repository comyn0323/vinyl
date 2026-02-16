import { db } from "../init";
import type { CurrentlyPlaying } from "../spotify/getCurrentlyPlaying";

export async function updatePresence(uid: string, data: CurrentlyPlaying | null): Promise<void> {
    const presenceRef = db.collection("presence").doc(uid);

    if (!data) {
        await presenceRef.set({
            isPlaying: false,
            trackId: "",
            trackName: "",
            artistName: "",
            albumArtUrl: "",
            progressMs: 0,
            updatedAt: new Date()
        }, { merge: true });
        return;
    }

    await presenceRef.set({
        trackId: data.trackId,
        trackName: data.trackName,
        artistName: data.artistName,
        albumArtUrl: data.albumArtUrl,
        isPlaying: data.isPlaying,
        progressMs: data.progressMs,
        rawSpotifyUri: data.rawSpotifyUri ?? null,
        updatedAt: new Date()
    }, { merge: true });
}
