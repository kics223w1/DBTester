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
    @StateObject var connectionService = ConnectionService.shared
    @StateObject var historyService = HistoryService.shared
    @StateObject var jsCore = JSCore.shared

    
    init()  {
        ProjectManagerService.shared.loadDataAtLaunch()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .alert(alertManager.title, isPresented: $alertManager.isOn) {
                    if !alertManager.isErrorMessageAlert {
                        TextField(alertManager.placeHolder, text: $alertManager.text)
                    }
                    
                    Button(alertManager.actionText, role: .cancel) {
                    }
               }
               .environmentObject(alertManager)
               .environmentObject(environmentString)
               .environmentObject(projectManagerService)
               .environmentObject(connectionService)
               .environmentObject(jsCore)
               .environmentObject(historyService)
               .onChange(of: alertManager.isOn) {
                   if !alertManager.text.isEmpty && alertManager.fromWho == "PopoverConnection" {
                       projectManagerService.addNewProject(name: alertManager.text)
                       alertManager.reset()
                   }
               }
               .onAppear {
                   Task {
                      await ConnectionService.shared.loadConnections()
                   }
               }
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
