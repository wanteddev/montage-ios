import SwiftUI
import Pretendard

@main
struct BlueprintApp: App {
    var body: some Scene {
        WindowGroup {
            ComponentListView()
                .onAppear {
                    _ = try? Pretendard.registerFonts()
                }
        }
    }
}
