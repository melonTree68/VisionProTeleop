---
name: view-recording
description: Assess or modify Vision Pro view recording, distinguishing full user-view capture from the app's existing source-video and tracking-data recordings.
---

# View recording

## Current behavior

The minimized recording button in `StatusView.swift` invokes `RecordingManager.startRecording()` / `stopRecordingManually()`. The existing manager records received network/UVC frames together with tracking, calibration, and optional simulation data. Sources feed it from `VideoFrameRenderer` in `ImmersiveView.swift`, `UVCCameraManager`, and simulation callbacks. Its output can contain `video.mp4`, `metadata.json`, `tracking.jsonl`, `mjdata.jsonl`, and `scene.usdz`.

## Full-view recording boundary

The requested full wearer-view recording (including physical-world passthrough), video-only output, and default Photos album has not been implemented. The project has no approved passthrough capture entitlement/license. After reviewing this platform boundary, the user explicitly chose to retain the existing recording behavior for this task. Keep the current recorder and storage options unchanged; any alternative recording path requires a new request.

Apple's supported composite-view capture requires a ReplayKit Broadcast Upload Extension, `com.apple.developer.screen-capture.include-passthrough`, an approved enterprise license, and the user pressing the system Start Broadcast control for each capture. Adding an entitlement string alone does not grant access. App-only `RPScreenRecorder` or incoming UVC/network frames do not fulfill full-view capture.

A future explicitly accepted app-only recording should use a separate video-only path, discard audio samples, and save only MP4. Photos album access and permission strings must be implemented alongside a working capture path, rather than advertising an unavailable destination. Do not silently change the recording source to satisfy the output format.

## Sources

- [Apple: Introducing enterprise APIs for visionOS](https://developer.apple.com/videos/play/wwdc2024/10139/) explains the combined view and mandatory broadcast control.
- [Apple: Building spatial experiences with enterprise APIs](https://developer.apple.com/documentation/visionos/building-spatial-experiences-for-business-apps-with-enterprise-apis) covers entitlement and license requirements, including development-only requests.
- [Vision Pro engineer: Passthrough in screen capture](https://developer.apple.com/forums/thread/757738) clarifies app capture versus broadcast capture.
