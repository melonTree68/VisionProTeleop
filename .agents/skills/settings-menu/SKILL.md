---
name: settings-menu
description: Change the tracking controller's quick settings and nested settings navigation in StatusView.swift.
---

# Settings menu

`StatusOverlay` in `Tracking Streamer/StatusView.swift` owns the settings panel. `ExpandedPanel.settings` shows frequent controls; `.moreSettings` shows the remaining categories; existing category cases render their detail panels. Back from a category returns to More Settings, then Back returns to Settings.

The former Visualizations → Hand Tracking and Hand Tracking → Enable Skeleton Overlay both bind to `DataManager.showHandJoints`; both Skeleton Opacity sliders bind to `handJointsOpacity`. The first settings page consolidates them into one Hand Tracking / Enable Skeleton Overlay toggle and one opacity slider. Keep their values shared and avoid restoring duplicate controls inside the category detail panels.

Visualizations details retain Hands Over AR and Head Gaze Ray. Hand Tracking details retain Prediction Offset. Video, recording, calibration, layout, cache, and accessory controls remain reachable through More Settings. Traditional Window is also in More Settings and binds to `useTraditionalWindow` in AppStorage; its scene lifecycle belongs to the window presentation implementation.

Verify navigation from Settings → More Settings → a category and both Back transitions. Check that opacity updates the immersive skeleton and remains disabled when its overlay is off.
