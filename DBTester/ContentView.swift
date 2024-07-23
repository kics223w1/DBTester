//
//  ContentView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TopNavigationBar()
            NavigationView {
                LeftPanelView()
                    .frame(width: 250)
                MainPanelView()
            }
            .offset(y: -8)
        }
        .previewLayout(.sizeThatFits)
        .background(Color(white: 0.1))
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
