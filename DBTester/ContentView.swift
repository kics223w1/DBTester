//
//  ContentView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            LeftPanelView()
            MainPanelView()
        }
    }
}

#Preview {
    ContentView()
}
