import type { CurrentlyPlaying } from "../spotify/getCurrentlyPlaying";

export function hasPresenceChanged(
    lastTrackId: string | null,
    current: CurrentlyPlaying | null
): boolean {
    const currentTrackId = current?.trackId ?? null;
    if (lastTrackId !== currentTrackId) return true;
    if (current && current.isPlaying === false) return true;
    return false;
}
