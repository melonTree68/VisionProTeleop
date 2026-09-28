---
name: main-status-panel
description: Maintain the compact tracking status panel and its local network address presentation in StatusView.swift.
---

# Main status panel

`StatusOverlay` in `Tracking Streamer/StatusView.swift` provides expanded and minimized controller presentations. The main panel starts with the app header and mode switch; the former Python-client explanation and capability list were removed to keep the controller compact. EgoRecord retains its camera requirements because they describe that mode's inputs.

`networkInfoSection` displays the addresses supplied by `getIPAddresses()` in one horizontal row, including en0 and utun4 when available, followed by Python and WebRTC connection cards. Connection state comes from local `DataManager.pythonClientIP` and `webrtcServerInfo`; the panel no longer observes remote signaling or displays a room code.

The minimized row preserves the existing expand, record, video visibility, world lock, and exit button order. Restart Streaming is appended as the sixth control in video mode and is also available on the expanded main panel. It calls `DataManager.requestStreamingRestart()` and reflects `isRestartingStream`.

Check both minimized and expanded layouts in the simulator after building. World-lock behavior and recording capture semantics belong to their respective implementations; changing this panel's presentation should preserve those actions.
