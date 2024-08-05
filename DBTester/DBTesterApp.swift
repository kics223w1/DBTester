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
    @StateObject var consoleLogService = ConsoleLogService()
    @StateObject var projectManagerService = ProjectManagerService.shared
    @StateObject var connectionService = ConnectionService.shared
    @StateObject var historyService = HistoryService.shared
    @StateObject var jsCore = JSCore.shared
    @StateObject var licenseService = LicenseService.shared
    
    
    init()  {
        ProjectManagerService.shared.loadDataAtLaunch()
        LicenseService.shared.validateLicense()
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
               .environmentObject(consoleLogService)
               .environmentObject(dbTesterCore)
               .environmentObject(licenseService)
               .onChange(of: alertManager.isOn) {
                   if !alertManager.text.isEmpty && alertManager.fromWho == "PopoverConnection" {
                       projectManagerService.addNewProject(name: alertManager.text)
                       alertManager.reset()
                   }
               }
               .onAppear {
                   Task {
                       do {
                          // Start both tasks concurrently
                          try await withThrowingTaskGroup(of: Void.self) { group in
                              group.addTask {
                                await ConnectionService.shared.loadConnections()
                              }
                              group.addTask {
                                await UpdaterService.shared.checkIsNewUpdate()
                              }
                              // Wait for all tasks to complete
                              try await group.waitForAll()
                          }
                      } catch {
                          // Handle any errors
                          print("Error in onAppear: \(error)")
                      }
                   }
               }
            
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .commands {
            CustomCommand()
        }
        
        
        WindowGroup(id : "Assistant") {
          AssistantWindow()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id : "ConnectionWindow") {
          ConnectionWindow()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        
        WindowGroup(id : "BuyDBTesterProWindow") {
            BuyDBTesterProWindow()
                .environmentObject(licenseService)
        }
        .defaultSize(width: 500, height: 400)
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
