//
//  MainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI

struct MainPanelView: View {
        
    var body: some View {
        VStack(spacing: 0) {
            TopMainPanelView()
        } 
        .edgesIgnoringSafeArea(.all) // Optional: to ignore safe area insets if needed
    }
}

#Preview {
    MainPanelView()
}
