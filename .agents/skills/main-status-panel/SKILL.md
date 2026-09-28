---
name: main-status-panel
description: Maintain the compact tracking status panel and its local network address presentation in StatusView.swift.
---

# Main status panel

`StatusOverlay` in `Tracking Streamer/StatusView.swift` provides expanded and minimized controller presentations. The main panel starts with the app header and mode switch; the former Python-client explanation and capability list were removed to keep the controller compact. EgoRecord also omits the introductory description and camera requirements block; its recording readiness checks remain in the recording action.

`networkInfoSection` displays the addresses supplied by `getIPAddresses()` in a two-column grid with equal-width cells and 8-point spacing matching the Python and WebRTC connection cards below. Each address, including en0 and utun4 when present, occupies half the row; additional interfaces wrap to another row. Preserve other addresses returned by the interface discovery function. Connection state comes from local `DataManager.pythonClientIP` and `webrtcServerInfo`; the panel no longer observes remote signaling or displays a room code.

The minimized row places Restart Streaming immediately before Exit: expand, record, video visibility, world lock, restart, exit in video mode. The expanded Restart Streaming action uses the same plain custom `menuItem` appearance as Settings and More Settings, with its disclosure indicator hidden. It calls `DataManager.requestStreamingRestart()` and reflects `isRestartingStream`.

Check both minimized and expanded layouts in the simulator after building. World-lock behavior and recording capture semantics belong to their respective implementations; changing this panel's presentation should preserve those actions.
