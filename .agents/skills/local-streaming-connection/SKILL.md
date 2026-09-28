---
name: local-streaming-connection
description: Maintain the Vision Pro app's direct gRPC and WebRTC connection path, including the disabled room-code remote connection feature.
---

# Direct streaming connection

The app accepts Python clients through gRPC and connects to their advertised WebRTC host/port. Remote room-code signaling is disabled: the app does not start `SignalingClient`, display room controls, or race local connections against a remote peer.

## Code path

- `GRPCServer.swift` receives the Python client and WebRTC endpoint; `DataManager` in `🥽AppModel.swift` holds `pythonClientIP` and `webrtcServerInfo`.
- `VideoStreamManager` in `ImmersiveView.swift` is shared with `CombinedStreamingView`. Its `start(imageData:)` waits for gRPC state, then calls `WebRTCClient.connect(to:port:)`.
- `stop(preserveForReconnect: false)` cancels the connection task and destroys the WebRTC client and renderers. The existing preserve mode keeps these objects for reconnection.
- `WebRTCClient.swift` and `SignalingClient.swift` retain the former remote implementation, but it has no active app entry point. Their removal is a separate cleanup decision.

Keep direct WebRTC media and simulation channels working when changing connection behavior. WebRTC's references to a remote SDP or remote ICE candidate describe the other peer and do not by themselves indicate the disabled room-code feature. Existing STUN configuration remains part of direct WebRTC negotiation.

## Validation

Search the Swift app for `SignalingClient`, `connectWithSignaling`, and calls to `signalingClient.connect()` to ensure a UI or alternate scene has not reintroduced an active remote entry point. Build the visionOS target. With a reachable Python client, confirm gRPC discovery followed by video/audio or simulation delivery; verify that hot restart can establish a fresh connection. Simulator-only checks cannot establish real-device tracking or external network success.
