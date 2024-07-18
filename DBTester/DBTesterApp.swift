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
    @StateObject var projectManagerService = ProjectManagerService.shared

    
    init() {
        ProjectManagerService.shared.loadDataAtLaunch()
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
               .environmentObject(alertManager)
               .environmentObject(environmentString)
               .environmentObject(projectManagerService)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        
        WindowGroup(id : "Ollama") {
          OllamaView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
       
    }
}
