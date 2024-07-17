import SwiftUI

struct BottomMainPanelView: View {
    @State private var selectedTab: String = "Tab1"
    @State private var tab1Text: String = "Content for Tab 1"
    @State private var tab2Text: String = "Content for Tab 2"
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
               
                
                HStack {
                    HStack(spacing: 0) {
                        Button(action: {
                            selectedTab = "Tab1"
                        }) {
                            Text("Tab 1")
                                .frame(width: geometry.size.width * 0.3, height: 30)
                                .cornerRadius(0)
                        }
                        .frame(width: geometry.size.width * 0.3, height: 30)
                        .cornerRadius(0)
                        .border(Color.black,  width: 0.5)
 
                        
                        Button(action: {
                            selectedTab = "Tab2"
                        }) {
                            Text("Tab 2")
                                .frame(width: geometry.size.width * 0.3, height: 30)
                                .cornerRadius(0)
                        }
                        .frame(width: geometry.size.width * 0.3, height: 30)
                        .cornerRadius(0)
                        .border(Color.black, width: 0.5)
                        .background(selectedTab == "Tab2" ? Color.gray.opacity(0.2) : Color.black)
                    }
                    .frame(width: geometry.size.width * 0.6, height: 30, alignment: .leading)
                    
                    HStack {
                        
                    }
                    .frame(width: geometry.size.width * 0.4, height: 30)
                }
                .frame(width: geometry.size.width, height: 30)
               
                
                // Text editor for the selected tab
                if selectedTab == "Tab1" {
                    TextEditor(text: $tab1Text)
                } else if selectedTab == "Tab2" {
                    TextEditor(text: $tab2Text)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alignmentGuide(.leading) { _ in 0 } // Aligns VStack to the leading edge of its parent
            
        }
    }
}

struct BottomMainPanelView_Previews: PreviewProvider {
    static var previews: some View {
        BottomMainPanelView()
    }
}
