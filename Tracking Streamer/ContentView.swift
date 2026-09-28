import SwiftUI
import Foundation

func dlog(_ msg: @autoclosure () -> String) {
    #if DEBUG
    print(msg())
    #endif
}

/// State shared by the head-attached controls and the movable system window.
@MainActor
final class StreamingControls: ObservableObject {
    @Published var hasFrames = false
    @Published var isMinimized = false
    @Published var showViewControls = false
    @Published var previewZDistance: Float?
    @Published var previewActive = false
    @Published var userInteracted = false
    @Published var videoMinimized = false
    @Published var previewStatusPosition: (x: Float, y: Float)?
    @Published var previewStatusActive = false
    @Published var isImmersiveActive = false
    let mujocoManager = CombinedMuJoCoManager()
}

struct StreamingControlsView: View {
    @EnvironmentObject private var controls: StreamingControls
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        StatusOverlay(
            hasFrames: $controls.hasFrames,
            showVideoStatus: true,
            isMinimized: $controls.isMinimized,
            showViewControls: $controls.showViewControls,
            previewZDistance: $controls.previewZDistance,
            previewActive: $controls.previewActive,
            userInteracted: $controls.userInteracted,
            videoMinimized: $controls.videoMinimized,
            videoFixed: $dataManager.videoPlaneFixedToWorld,
            previewStatusPosition: $controls.previewStatusPosition,
            previewStatusActive: $controls.previewStatusActive,
            mujocoManager: controls.mujocoManager
        )
    }
}

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @EnvironmentObject private var controls: StreamingControls
    @AppStorage("useTraditionalWindow") private var useTraditionalWindow = false
    @State private var startupError: String?

    var body: some View {
        Group {
            if controls.isImmersiveActive {
                StreamingControlsView()
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                VStack(spacing: 16) {
                    if let startupError {
                        Text(startupError)
                        Button("Retry") {
                            Task { await startStreaming() }
                        }
                    } else {
                        ProgressView("Starting streaming…")
                    }
                }
                .padding(32)
            }
        }
        .task {
            if !controls.isImmersiveActive {
                await startStreaming()
            }
        }
        .onChange(of: controls.isImmersiveActive) { _, active in
            if !active { startupError = "The streaming space was closed." }
        }
        .onDisappear {
            // Closing the movable controls restores the in-space controls.
            if controls.isImmersiveActive { useTraditionalWindow = false }
        }
    }

    private func startStreaming() async {
        startupError = nil
        switch await openImmersiveSpace(id: "combinedStreamSpace") {
        case .opened:
            if !useTraditionalWindow { dismissWindow(id: "mainWindow") }
        case .userCancelled:
            startupError = "Streaming was cancelled."
        case .error:
            startupError = "Unable to open the streaming space."
        @unknown default:
            startupError = "Unable to open the streaming space."
        }
    }
}

func getIPAddresses() -> [(name: String, address: String)] {
    var addresses: [(name: String, address: String)] = []
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }

            guard let interface = ptr?.pointee else { continue }
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) {
                let name: String = String(cString: (interface.ifa_name))
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                let address = String(cString: hostname)
                if address != "127.0.0.1" {
                    addresses.append((name: name, address: address))
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return addresses
}


func getWiFiName() -> String? {
  // CNCopyCurrentNetworkInfo is unavailable in visionOS
  // WiFi SSID access is restricted on this platform
  return nil
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
