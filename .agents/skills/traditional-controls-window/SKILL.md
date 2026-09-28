---
name: traditional-controls-window
description: Maintain the switch between head-attached streaming controls and a draggable visionOS system window.
---

# Movable streaming controls

Settings > More Settings > Traditional Window uses `@AppStorage("useTraditionalWindow")`, default false. `App.swift` supplies one app-owned `StreamingControls` object to `mainWindow` and `combinedStreamSpace`. It holds the shared UI bindings and the combined MuJoCo manager. `StreamingControlsView` builds the same `StatusOverlay` in both presentations.

`CombinedStreamingView` observes the preference to open/dismiss `mainWindow` and enable/disable its status attachment. Keep the streaming RealityView alive during this switch so connections and tracking continue. The native window uses SwiftUI's standard window chrome and `.windowResizability(.contentSize)`. Its `ContentView` applies `.fixedSize(horizontal: false, vertical: true)` to the controls: without that ideal-height constraint, the window can retain the compact startup height and compress the mode selector when streaming first appears.

`ContentView` automatically starts immersion only when it is not already active. A window opened from Settings reuses the running session. Closing the movable window restores head-attached controls by resetting the preference, preventing loss of the control entry point. If the system closes immersion while the native window remains, the window displays a retry action rather than immediately reopening immersion.

Validate toggling both directions with minimized and expanded controls, drag the native window using its system bar, close it to restore the attachment, and confirm video/connection state is retained. StatusOverlay invalidates its warning and status timers on disappearance so reopening the native window does not accumulate updates to shared state. Window presentation does not change Full Space tracking restrictions; see `visionos-tracking-limits`.
