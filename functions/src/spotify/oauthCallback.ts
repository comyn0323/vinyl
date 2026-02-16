import { onRequest } from "firebase-functions/v2/https";
import { auth, db } from "../init";
import { spotifyClientId, spotifyClientSecret } from "../config";

export const oauthCallback = onRequest(async (req, res) => {
    try {
        const { code, redirectUri } = req.body || {};
        if (!code || !redirectUri) {
            res.status(400).json({ error: "missing_code_or_redirect" });
            return;
        }

        const tokenResponse = await fetch("https://accounts.spotify.com/api/token", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded",
                Authorization: `Basic ${Buffer.from(`${spotifyClientId.value()}:${spotifyClientSecret.value()}`).toString("base64")}`
            },
            body: new URLSearchParams({
                grant_type: "authorization_code",
                code,
                redirect_uri: redirectUri
            })
        });

        if (!tokenResponse.ok) {
            const errorText = await tokenResponse.text();
            res.status(400).json({ error: "spotify_token_error", detail: errorText });
            return;
        }

        const tokenJson = await tokenResponse.json();
        const accessToken = tokenJson.access_token as string;
        const refreshToken = tokenJson.refresh_token as string;
        const expiresIn = (tokenJson.expires_in as number | undefined) ?? 3600;

        const meResponse = await fetch("https://api.spotify.com/v1/me", {
            headers: { Authorization: `Bearer ${accessToken}` }
        });
        const meJson = await meResponse.json();
        const spotifyUserId = meJson.id as string;

        const uid = `spotify_${spotifyUserId}`;

        try {
            await auth.getUser(uid);
        } catch {
            await auth.createUser({ uid, displayName: meJson.display_name || "Spotify User" });
        }

        const now = new Date();
        const expiresAt = new Date(Date.now() + expiresIn * 1000);

        await db.collection("users").doc(uid).set({
            spotifyUserId,
            sharingEnabled: false,
            createdAt: now,
            updatedAt: now
        }, { merge: true });

        await db.collection("tokens").doc(uid).set({
            accessToken,
            refreshToken,
            accessTokenExpiresAt: expiresAt,
            updatedAt: now
        }, { merge: true });

        const customToken = await auth.createCustomToken(uid);

        res.json({ firebaseCustomToken: customToken, spotifyUserId });
    } catch (error) {
        res.status(500).json({ error: "server_error", detail: String(error) });
    }
});
