//
//  MainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI

struct MainPanelView: View {
        
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                TopNavigationBar()
                TopMainPanelView()
                Divider().background(Color.black)
                BottomMainPanelView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height) // Use geometry's width and height
        }
        .edgesIgnoringSafeArea(.all) // Optional: to ignore safe area insets if needed
    }
}

#Preview {
    MainPanelView()
}
