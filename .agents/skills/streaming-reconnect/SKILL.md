---
name: streaming-reconnect
description: Maintain the refresh connection control and in-place restart of Tracking Streamer's gRPC and WebRTC connections.
---

# Restart streaming connections

The refresh control calls `DataManager.requestStreamingRestart()`. `StateChangeModifiers` in `CombinedStreamingView.swift` closes WebRTC, cancels and awaits both gRPC server tasks, clears the old stream display and connection discovery state, then starts the servers and WebRTC waiting loop again. The AR scene stays open.

`GRPCServerManager.shared` owns the hand-tracking server task (port 12345). `CombinedMuJoCoManager` owns its simulation server task (port 50051). Await task completion before reusing a listening port; graceful shutdown alone waits for live streaming RPCs. Keep the refresh control disabled while `isRestartingStream` is true. Generation zero denotes a fresh wait for connection; the Python-disconnect observer must not tear down this fresh wait after a manual refresh.

Validate repeated refreshes with and without a connected Python client. Confirm no port-in-use errors, a subsequent Python connection can stream, and the controls and immersive scene remain present. A Python client whose RPC ended may need to reconnect.

## Known issues

Closing a WebRTC peer can enqueue its ICE callback on the main actor after a replacement connection starts. `WebRTCClient` checks that the callback's peer is still its current peer before changing global connection status, media flags, or invoking recording callbacks. Keep this identity check inside the dispatched task so already-queued callbacks from a closed peer are ignored.
