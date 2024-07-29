import SwiftUI

class AlertManager: ObservableObject {
    @Published var isOn: Bool = false
    @Published var isErrorMessageAlert : Bool = false
    @Published var text : String = ""
    @Published var title: String = "Title"
    @Published var placeHolder : String = ""
    @Published var actionText : String = "Create"
    @Published var fromWho: String = ""
    
    func reset() {
        self.text = ""
        self.isOn = false
        self.fromWho = ""
        self.isErrorMessageAlert = false
    }
    
    func openErrorMessageAlert(text: String ,fromWho: String) {        
        self.isErrorMessageAlert = true
        self.title = text
        self.isOn = true
        self.fromWho = fromWho
        self.actionText = "Cancel"
        
        print("text: \(self.text)")
    }
}
