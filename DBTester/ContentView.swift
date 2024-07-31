//
//  ContentView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @State var mainPanelTab : MainPanelTab = .unitTest
    
    var body: some View {
        VStack {
            TopNavigationBar(mainPanelTab: $mainPanelTab)
                .background(Color.blue)
            
                NavigationView {
                    LeftPanelView()
                        .frame(width: 250)
                    MainPanelView(mainPanelTab: $mainPanelTab)
                }
        }
        .previewLayout(.sizeThatFits)
        .background(Color(red: 55/255, green: 55/255, blue: 53/255))
        .ignoresSafeArea()
    }
}


#Preview {
    ContentView()
}
