---
name: visionos-simulator
description: Build Tracking Streamer in Xcode and smoke-test the visionOS Simulator, accounting for simulator limitations.
---

# Simulator workflow

Open `Tracking Streamer.xcodeproj`, select scheme `VisionProTeleop` and `Apple Vision Pro` under visionOS Simulator, then Build (Command-B) with Simulator closed. Wait for `Build Succeeded` before Run (Command-R) opens Simulator. This order avoids simulator resource usage during the build. Use Computer for Xcode and Simulator when requested by the user.

The app now opens the combined streaming space automatically. Verify the tracking controller appears directly, the local addresses share one row, and the gRPC server listens on port 12345. Check both attachment and Traditional Window presentation; the latter should have the system window bar and render the full controller without vertical clipping. Its preference is `useTraditionalWindow` in AppStorage.

For a minimal transport smoke test, use the project `avp-teleop` Python environment and load `avp_stream/grpc_msg/handtracking_pb2.py` directly with importlib. Importing the whole `avp_stream` package brings unrelated dependencies. Call `/handtracking.HandTrackingService/StreamHandUpdates` with `channel.unary_stream`, encode discovery as `Head.m00 = 888`, encode 127.0.0.1 in m01/m02/m03/m10, and set m30 to `DataManager.minimumPythonVersionCode`. Receive several responses and cancel. This checks transport and message shape; simulator skeleton data does not validate real tracking.

## Verified baseline

On 2026-09-28, the updated app built, installed, launched directly into tracking, and displayed en0 and utun4 on the same row. A localhost gRPC smoke test received five updates with 27 joints for each hand and cancelled successfully.

Launching with the temporary `-useTraditionalWindow YES` argument displayed the native system window bar. After applying ideal content sizing and rebuilding successfully, a follow-up screenshot confirmed the mode selector rendered fully without compression. Automated clicks did not visibly open Settings, and the Computer connection subsequently closed, so menu navigation, the Traditional Window toggle, and the Restart Streaming button have not been fully verified through UI interaction. End-to-end WebRTC video/audio and physical-device tracking remain unverified.

## Known issues

- `Tracking Streamer/🥽AppModel.swift` skips hand tracking in `run()` under `targetEnvironment(simulator)`; validate real tracking on a device.
- Computer clicks previously failed to advance the old onboarding buttons while manual user clicks succeeded. Current Settings clicks show the same automation limitation; do not infer a broken app button from this alone.
- Previously observed warnings included visionOS 2.1 linking LiveKitWebRTC built for 2.2, missing `vpt4.mp4` and `vpt5.mp4` assets, OpenCV headers, and iCloud `No account`. An old `Update Signing: No Accounts` report also remained visible during a successful run; check current build/run evidence before diagnosing a blocker.
- A previous immersive run produced repeated SwiftUI `Modifying state during view update` warnings. The runtime issue stack pointed to closure #2 in `CombinedStreamingView.baseRealityView.getter` invoking `State.wrappedValue.setter`; this remains an observed issue requiring separate diagnosis.
