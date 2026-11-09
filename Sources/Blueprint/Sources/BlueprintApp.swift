import SwiftUI
import Pretendard

// blueprint-testflight 워크플로 서명 테스트용 변경 (머지하지 않음, 4차)
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
