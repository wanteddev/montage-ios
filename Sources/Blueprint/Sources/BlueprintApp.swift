import SwiftUI
import Pretendard

@main
struct BlueprintApp: App {
    init() {
        _ = try? Pretendard.registerFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            ComponentListView()
        }
    }
}
