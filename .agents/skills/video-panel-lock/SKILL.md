---
name: video-panel-lock
description: Review the minimized fourth button and world-fixed video panel behavior without changing simulator-sensitive tracking logic without evidence.
---

# Video panel lock

## Existing behavior and call chain

The fourth minimized button in `StatusView.swift` toggles its `videoFixed` binding. `CombinedStreamingView` and `ImmersiveView` bind this to `DataManager.videoPlaneFixedToWorld`.

When enabled, the view's change handler computes `fixedWorldTransform = Head * offset`, where `Head` is the device anchor's `originFromAnchorTransform` and the offset incorporates video distance, height, and auto-tilt. The RealityView update moves `videoRoot` under `videoWorldAnchor` and applies the saved transform. Disabling the lock reparents `videoRoot` to `videoAnchor` (a head anchor).

The status controls are a separate `statusContainer` under `statusHeadAnchor`, and continue to follow the head. The lock's existing implementation controls the video panel. Changing it to control the status UI would change the feature's semantics.

## Review outcome and validation boundary

The simulator complaint was independently reviewed across button bindings, handlers, entity parenting, and the device-anchor data source. No obvious code error was established, so the lock implementation was left unchanged as requested. `Head` starts as an identity matrix and actual tracking availability affects its updates; a simulator symptom alone does not establish a real-device bug.

On device, receive video, enable the lock, move the headset, and check that the video stays at its captured world pose; disable it and confirm head-following resumes. Treat the status controls separately. Before a bug fix, reproduce the problem and have another agent independently review the complete relevant call chain. Do not add fallback transforms or simulator-specific lock behavior based only on missing hardware tracking.
