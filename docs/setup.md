# vinyl MVP setup

## Prereqs
- Xcode 16+
- Firebase CLI
- Apple Developer account
- Spotify Developer app (Authorization Code flow)
- Node 20 (Functions)

## iOS app setup
1) Add Firebase SDK via Swift Package Manager:
   - https://github.com/firebase/firebase-ios-sdk
   - Products: FirebaseAuth, FirebaseFirestore, FirebaseCore
2) Add GoogleService-Info.plist for project `vinyl-9538c` to the Xcode target.
3) Bundle ID (현재 사용중): `com.vinyl.app`
4) Add URL Types to the iOS target:
   - Identifier: spotify
   - URL Schemes: `vinyl`
5) Add Associated App Group:
   - `group.com.vinyl.app`
6) Add Background Modes:
   - Remote notifications
7) Add a Widget Extension target and Live Activity extension target:
   - Include files:
     - `vinyl/vinyl/Widgets/VinylWidgetDefinitions.swift`
     - `vinyl/vinyl/Widgets/VinylLiveActivityWidget.swift`
   - Add a new file in the extension target:

```swift
import WidgetKit

@main
struct VinylWidgetBundle: WidgetBundle {
    var body: some Widget {
        VinylSmallWidget()
        VinylMediumWidget()
        VinylLiveActivityWidget()
    }
}
```

## Spotify setup
- Create a Spotify app and set redirect URI to `vinyl://oauth-callback`.
- Put the Client ID in `vinyl/vinyl/Utilities/AppConfig.swift`.

## Firebase Functions setup
1) `cd vinyl/functions`
2) `npm install`
3) Set function params:
   - `SPOTIFY_CLIENT_ID`
   - `SPOTIFY_CLIENT_SECRET`
   - `SPOTIFY_REDIRECT_URI`
   - `APNS_TEAM_ID`
   - `APNS_KEY_ID`
   - `APNS_PRIVATE_KEY` (p8 contents, newlines as \n)
   - `APNS_BUNDLE_ID` (예: com.vinyl.com)
4) `npm run build`
5) `firebase deploy --only functions`

## Firestore rules
- Apply rules from `vinyl/docs/firestore.rules`.

## Run
1) Build and run the iOS app in Xcode.
2) Login with Spotify.
3) Toggle sharing ON.
4) Send/accept friend requests and pin friends (max 5).
5) Verify presence updates in Firestore within 1 minute.
6) Verify Live Activity updates within 30 seconds after track change.
