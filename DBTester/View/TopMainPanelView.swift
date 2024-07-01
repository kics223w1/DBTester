//
//  TopMainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 30/6/24.
//

import SwiftUI

struct TopMainPanelView: View {
    @State private var selectedTab: String = "Tab1"
    @State private var tab1Text: String = "Content for Tab 1"
    @State private var tab2Text: String = "Content for Tab 2"
        
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                   
                }
                .frame(width: geometry.size.width * 0.6, height: 0)
                .background(Color.red)

               
                
                // Text editor for the selected tab
                if selectedTab == "Tab1" {
                    TextEditor(text: $tab1Text)
                } else if selectedTab == "Tab2" {
                    TextEditor(text: $tab2Text)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alignmentGuide(.leading) { _ in 0 }
            // Aligns VStack to the leading edge of its parent
        }
    }
}

#Preview {
    TopMainPanelView()
}
