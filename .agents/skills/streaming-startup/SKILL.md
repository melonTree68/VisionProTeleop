---
name: streaming-startup
description: Maintain automatic launch into Tracking Streamer's immersive streaming scene and startup error handling.
---

# Automatic streaming startup

`App.swift` starts the tracking gRPC server on launch. `ContentView.swift` automatically opens `combinedStreamSpace`; `CombinedStreamingView` starts ARKit, video, and MuJoCo services when it appears. Cloud sign-in and iOS promotion screens no longer gate startup. Cloud account configuration remains in Settings.

Only dismiss the launch window after `openImmersiveSpace` returns `.opened`. A cancelled or failed opening leaves a retry action. Do not automatically reopen immersion after the system dismisses it to show Home or another app.

Validate a cold simulator launch after building: no START page or onboarding should appear, and the streaming controls should appear. Simulator ARKit limitations are covered by `visionos-simulator`.
