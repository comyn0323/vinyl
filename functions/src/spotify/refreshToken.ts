import { db } from "../init";
import { spotifyClientId, spotifyClientSecret } from "../config";

export async function refreshSpotifyToken(uid: string): Promise<string> {
    const tokenRef = db.collection("tokens").doc(uid);
    const tokenSnap = await tokenRef.get();
    const refreshToken = tokenSnap.get("refreshToken");

    if (!refreshToken) {
        throw new Error("missing_refresh_token");
    }

    const response = await fetch("https://accounts.spotify.com/api/token", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            Authorization: `Basic ${Buffer.from(`${spotifyClientId.value()}:${spotifyClientSecret.value()}`).toString("base64")}`
        },
        body: new URLSearchParams({
            grant_type: "refresh_token",
            refresh_token: refreshToken
        })
    });

    if (!response.ok) {
        throw new Error(`refresh_failed_${response.status}`);
    }

    const json = await response.json();
    const accessToken = json.access_token as string;
    const expiresIn = (json.expires_in as number | undefined) ?? 3600;

    await tokenRef.set({
        accessToken,
        accessTokenExpiresAt: new Date(Date.now() + expiresIn * 1000),
        updatedAt: new Date()
    }, { merge: true });

    return accessToken;
}
