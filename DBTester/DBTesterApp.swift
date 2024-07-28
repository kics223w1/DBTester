//
//  DBTesterApp.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI


@main
struct DBTesterApp: App {
    @StateObject var alertManager = AlertManager()
    @StateObject var environmentString = EnvironmentString()
    @StateObject var dbTesterCore = DBTesterCore()
    @StateObject var projectManagerService = ProjectManagerService.shared
    @StateObject var jsCore = JSCore.shared

    
    init()  {
        ProjectManagerService.shared.loadDataAtLaunch()
        ConnectionService.shared.loadConnections()
    }
    


       
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(alertManager.title, isPresented: $alertManager.isOn) {
                    TextField(alertManager.placeHolder, text: $alertManager.text)
                        .onSubmit {
                        
                        }
                    Button(alertManager.actionText, role: .cancel) { }
               }
                .onAppear {
                    Task {
                        await dbTesterCore.connectDatabase()
                    }
                }
               .environmentObject(alertManager)
               .environmentObject(environmentString)
               .environmentObject(projectManagerService)
               .environmentObject(jsCore)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        
        WindowGroup(id : "Ollama") {
          OllamaView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id : "ConnectionWindow") {
          ConnectionWindow()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id : "ConnectionListWindow") {
            ConnectionListWindow(connections: ConnectionService.shared.connections)
                .background(WindowAccessor { window in
                    if let window = window {
                        window.setContentSize(NSSize(width: 300, height: 500))
                        window.contentView?.wantsLayer = true
                        window.contentView?.layer?.backgroundColor = NSColor.black.cgColor
                    }
                })
                .background(Color(red: 42/255, green: 42/255, blue: 42/255))
        }
        .windowStyle(HiddenTitleBarWindowStyle())
       
    }
}


struct WindowAccessor: NSViewRepresentable {
    var onWindow: (NSWindow?) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.onWindow(view.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
