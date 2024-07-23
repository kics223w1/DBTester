import SwiftUI

enum Tab: String, Codable {
    case treeView = "Treeview"
    case history = "History"
}

struct LeftPanelView: View {
    @State private var selectedTab : Tab = Tab.treeView
    @Environment(\.openWindow) private var openWindow
    
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                Text("Treeview")
                    .foregroundColor(selectedTab == Tab.treeView ? Color.white : Color.gray)
                    .onTapGesture {
                        if selectedTab != Tab.treeView {
                            selectedTab = Tab.treeView
                        }
                    }
                    
                Text("History")
                    .foregroundColor(selectedTab == Tab.history ? Color.white : Color.gray)
                    .onTapGesture {
                        if selectedTab != Tab.history {
                            selectedTab = Tab.history
                        }
                    }
                
                Text("Ollama")
                    .foregroundColor(Color.gray)
                    .onTapGesture {
                        openWindow(id: "Ollama")
                    }
            }
            .frame(height: 20)
          
            
            
            if selectedTab == Tab.treeView {
                TreeView()
            } else {
                HistoryView()
            }
        }
    }
}

struct LeftPanelView_Previews: PreviewProvider {
    static var previews: some View {
        LeftPanelView()
    }
}
