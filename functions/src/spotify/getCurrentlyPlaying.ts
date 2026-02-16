import { db } from "../init";
import { refreshSpotifyToken } from "./refreshToken";

export interface CurrentlyPlaying {
    trackId: string;
    trackName: string;
    artistName: string;
    albumArtUrl: string;
    isPlaying: boolean;
    progressMs: number;
    rawSpotifyUri?: string;
}

export async function getCurrentlyPlaying(uid: string): Promise<CurrentlyPlaying | null> {
    const tokenSnap = await db.collection("tokens").doc(uid).get();
    let accessToken = tokenSnap.get("accessToken") as string | undefined;
    const expiresAt = tokenSnap.get("accessTokenExpiresAt")?.toDate?.() as Date | undefined;

    if (!accessToken || (expiresAt && expiresAt.getTime() <= Date.now())) {
        accessToken = await refreshSpotifyToken(uid);
    }

    let response = await fetch("https://api.spotify.com/v1/me/player/currently-playing", {
        headers: { Authorization: `Bearer ${accessToken}` }
    });

    if (response.status === 401) {
        accessToken = await refreshSpotifyToken(uid);
        response = await fetch("https://api.spotify.com/v1/me/player/currently-playing", {
            headers: { Authorization: `Bearer ${accessToken}` }
        });
    }

    if (response.status === 204) {
        return null;
    }

    if (!response.ok) {
        throw new Error(`spotify_currently_playing_${response.status}`);
    }

    const json = await response.json();
    if (!json || json.currently_playing_type !== "track" || !json.item) {
        return null;
    }

    return {
        trackId: json.item.id,
        trackName: json.item.name,
        artistName: json.item.artists?.map((a: any) => a.name).join(", ") ?? "",
        albumArtUrl: json.item.album?.images?.[0]?.url ?? "",
        isPlaying: Boolean(json.is_playing),
        progressMs: json.progress_ms ?? 0,
        rawSpotifyUri: json.item.uri
    };
}
