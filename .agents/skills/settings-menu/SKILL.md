---
name: settings-menu
description: Change the tracking controller's quick settings and nested settings navigation in StatusView.swift.
---

# Settings menu

`StatusOverlay` in `Tracking Streamer/StatusView.swift` owns the settings panel. `ExpandedPanel.settings` shows frequent controls; `.moreSettings` shows the remaining categories; existing category cases render their detail panels. Back from a category returns to More Settings, then Back returns to Settings.

The first Settings page preserves four controls in two labeled groups: Visualizations has Hand Tracking and Skeleton Opacity; Hand Tracking has Enable Skeleton Overlay and Skeleton Opacity. Both toggles bind to `DataManager.showHandJoints`; both sliders bind to `handJointsOpacity` with range 0.1–1.0 and step 0.05. Preserve the original distinct interactions: Visualizations dims/disables its slider while the overlay is off, while Hand Tracking leaves its slider adjustable. Keep the four controls visible even though their values are shared. The category detail panels contain only their remaining controls.

Visualizations details retain Hands Over AR and Head Gaze Ray. Hand Tracking details retain Prediction Offset. Video, recording, calibration, layout, cache, and accessory controls remain reachable through More Settings. Traditional Window is also in More Settings and binds to `useTraditionalWindow` in AppStorage; its scene lifecycle belongs to the window presentation implementation.

Settings and More Settings use the original `menuItem` appearance: a custom row with `.buttonStyle(.plain)`, 12-point vertical / 4-point horizontal padding, and an 8-point corner radius. Preserve its active color and disclosure indicator when changing navigation.

Verify navigation from Settings → More Settings → a category and both Back transitions. Check that both toggles and both opacity values stay synchronized; with the overlay off, only the Visualizations slider becomes disabled.

## Known issues

Consolidating the two pairs into one toggle and slider loses the user-requested grouping and the Hand Tracking slider’s always-adjustable behavior. Restore all four original controls when promoting them to quick settings.
