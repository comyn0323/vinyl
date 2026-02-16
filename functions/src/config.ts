import { defineString } from "firebase-functions/params";

export const spotifyClientId = defineString("SPOTIFY_CLIENT_ID");
export const spotifyClientSecret = defineString("SPOTIFY_CLIENT_SECRET");
export const spotifyRedirectUri = defineString("SPOTIFY_REDIRECT_URI");
export const apnsTeamId = defineString("APNS_TEAM_ID");
export const apnsKeyId = defineString("APNS_KEY_ID");
export const apnsPrivateKey = defineString("APNS_PRIVATE_KEY");
export const apnsBundleId = defineString("APNS_BUNDLE_ID");
