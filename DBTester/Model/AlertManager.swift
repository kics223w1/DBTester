import SwiftUI

class AlertManager: ObservableObject {
    @Published var isOn: Bool = false
    @Published var text : String = ""
    @Published var title: String = "Title"
    @Published var placeHolder : String = ""
    @Published var actionText : String = "Create"
    @Published var fromWho: String = ""
    
    
    func reset() {
        self.text = ""
        self.isOn = false
        self.fromWho = ""
    }
}
