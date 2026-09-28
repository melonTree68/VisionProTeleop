import SwiftUI

@main
struct VisionProTeleopApp: App {
    @StateObject private var imageData = ImageData()
    @StateObject private var appModel = 🥽AppModel()
    @StateObject private var controls = StreamingControls()
    
    var body: some Scene {
        WindowGroup(id: "mainWindow") {
            ContentView()
                .environmentObject(controls)
        }
        .windowResizability(.contentSize)
        
        // Hand tracking view (existing)
        ImmersiveSpace(id: "immersiveSpace") {
            🌐RealityView(model: appModel)
        }
        
        // Video streaming view (new)
        ImmersiveSpace(id: "videoStreamSpace") {
            ImmersiveView()
                .environmentObject(imageData)
        }
        
        // MuJoCo streaming view (new)
        ImmersiveSpace(id: "mujocoStreamSpace") {
            MuJoCoStreamingView()
        }
        
        // Combined streaming view (Video + Audio + MuJoCo Sim)
        ImmersiveSpace(id: "combinedStreamSpace") {
            CombinedStreamingView()
                .environmentObject(imageData)
                .environmentObject(controls)
        }
    }
    
    init() {
        dlog("🚀 [DEBUG] VisionProTeleopApp.init() - App launching...")
        🧑HeadTrackingComponent.registerComponent()
        🧑HeadTrackingSystem.registerSystem()
        
        // Start gRPC server immediately when app launches
        dlog("🌐 [DEBUG] Starting gRPC server on app launch...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            dlog("🔧 [DEBUG] Calling startServer() from app init...")
            startServer()
        }
        
        // Configure settings sync from iOS
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            Task { @MainActor in
                VisionOSSettingsSync.shared.configure(
                    dataManager: DataManager.shared,
                    recordingManager: RecordingManager.shared
                )
                dlog("☁️ [DEBUG] VisionOS settings sync configured")
            }
        }
    }
}

