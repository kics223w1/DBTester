//
//  ContentView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI
import AppKit

class HostingWindowController<Content>: NSWindowController where Content: View {
    init(rootView: Content) {
        let hostingController = NSHostingController(rootView: rootView)
        let window = NSWindow(contentViewController: hostingController)
        super.init(window: window)
        
        // Customize the window here
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        
        // Set window frame
        window.setFrame(NSRect(x: 0, y: 0, width: 800, height: 600), display: true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct ContentView: View {
    var body: some View {
        VStack {
            TopNavigationBar()
                .background(Color.blue)
            

                
                NavigationView {
                    LeftPanelView()
                        .frame(width: 250)
                    MainPanelView()
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
