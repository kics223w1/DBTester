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
                       TopMainPanelView()
                           .frame(height: geometry.size.height * 0.5)
                       
                       Divider().background(Color.black)
                       
                       BottomMainPanelView()
                   }
               }
    }
}

#Preview {
    MainPanelView()
}
