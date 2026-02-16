# vinyl MVP

vinyl은 Spotify Now Playing을 실시간으로 공유하고, 핀한 친구의 상태를 위젯/Live Activity로 보여주는 iOS 앱입니다.

## 구조
- /vinyl: iOS 앱
- /functions/src: Firebase Cloud Functions
- /docs: Firestore rules / setup 문서

## 실행
1) Firebase/Spotify 설정: `docs/setup.md`
2) iOS 앱 빌드/실행 (Xcode)
3) Functions 배포 및 Firestore rules 적용

## 디자인 시스템 요약
- Background: #0B0B0B
- Surface: #121212
- Text Primary: #F5F5F5
- Text Secondary: rgba(245,245,245,0.70)
- Divider: rgba(245,245,245,0.10)
- Accent: Neon Violet #7C3AED
- Card radius: 20, AlbumArt radius: 16, 8pt grid

## 테스트 체크리스트
- Spotify 로그인 성공
- sharing ON 시 1분 내 presence 문서 생성/갱신
- 친구 요청 승인 후 friends 문서 생성
- 친구 최대 10명 제한
- 핀 최대 5명 제한
- 핀한 친구의 곡 변경 시 30초 내 Live Activity 업데이트

## 주의
- secrets/토큰 하드코딩 금지
- tokens 컬렉션은 서버 전용
