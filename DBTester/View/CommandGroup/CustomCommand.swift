import SwiftUI

struct CustomCommand: Commands {    
        
    @Environment(\.openWindow) private var openWindow
    
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button(action: {
                openWindow(id: "BuyDBTesterProWindow")
            }) {
                Text("License Manager")
            }
        }
    }
}
