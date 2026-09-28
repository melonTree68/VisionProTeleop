---
name: visionos-tracking-limits
description: Assess requests for hand/world tracking alongside other visionOS apps or while the app is backgrounded.
---

# Tracking and visionOS app coexistence

This app streams ARKit hand and world tracking in `combinedStreamSpace`. Apple exposes this data only while an app presents a Full Space and other apps are hidden. Opening a Home/system surface or another app may dismiss immersion; the existing disappearance cleanup stops immersive services.

Continuous tracking alongside other apps or arbitrary background keepalive was intentionally declined because it conflicts with the supported platform model. Do not add background audio, repeated immersive reopening, or other keepalive workarounds. A conventional controls window changes placement and dragging, not ARKit eligibility.

Sources: [ARKit data access](https://developer.apple.com/documentation/visionos/setting-up-access-to-arkit-data), [ImmersiveSpace](https://developer.apple.com/documentation/swiftui/immersivespace).
