//
//  MainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI
import Combine
import CodeEditor

enum MainPanelTab {
    case unitTest
    case sqlCommand
    case consoleLog
}

struct MainPanelView: View {
    @State private var content: String = ""
    @State private var contentConsoleLog : String = ""
    @State private var debounceWorkItem: DispatchWorkItem?
    
    @Binding var mainPanelTab : MainPanelTab

    @EnvironmentObject var environmentString: EnvironmentString
    @EnvironmentObject var projectManagerService: ProjectManagerService
    @EnvironmentObject var jsCore: JSCore

    private func loadContentFromFile() {
        let filePath = self.getFilePath()

        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
            content = fileContent
        } catch {
            print("Failed to read file: \(error.localizedDescription)")
            content = ""
        }
    }

    private func saveContentToFile() {
        let filePath = self.getFilePath()

        do {
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write file: \(error.localizedDescription)")
        }
    }
    
    private func getFilePath() -> String {
        guard mainPanelTab != MainPanelTab.consoleLog else { return ""}
        let isUnitTestVisible = mainPanelTab == MainPanelTab.unitTest
        
        let folderPath = isUnitTestVisible ? projectManagerService.getUnitTestFolderPath() : projectManagerService.getSQLCommandFolderPath()
        let fileName = isUnitTestVisible ? environmentString.selectedtUnitTestFileName : environmentString.selectedSQLCommandFileName
        let filePath = (folderPath.path as NSString).appendingPathComponent(fileName)
        
        return filePath
    }
    
    private func debounceSaveContentToFile() {
        // Cancel the previous work item if it exists
        debounceWorkItem?.cancel()

        // Create a new work item
        let newWorkItem = DispatchWorkItem {
            saveContentToFile()
        }

        // Schedule the work item with a 200ms delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: newWorkItem)
        debounceWorkItem = newWorkItem
    }
    
    private func openFolderInVSCode() {
        let folderPath = projectManagerService.getProjecetFolderPath().path
        let quotedFolderPath = "\"\(folderPath)\""
        
        print(quotedFolderPath)
        
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/local/bin/code")
        process.arguments = [quotedFolderPath]
    
        do {
            try process.run()
        } catch {
            print("Failed to open folder in VS Code: \(error)")
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    HStack {
                        Text("JS")
                            .foregroundColor(mainPanelTab == MainPanelTab.unitTest ? .green: .gray)
                            .fontWeight(.bold)
                        Text(environmentString.selectedtUnitTestFileName.dropLast(3))
                            .frame(height: 30)
                            .foregroundColor(mainPanelTab == MainPanelTab.unitTest ? .white: .gray)
                    }
                    .frame(width: 150, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )
                    .onTapGesture {
                        mainPanelTab = MainPanelTab.unitTest
                    }
                    
                    HStack {
                        Text("SQL")
                            .foregroundColor(mainPanelTab == MainPanelTab.sqlCommand ? .green: .gray)
                            .fontWeight(.bold)
                        Text(environmentString.selectedSQLCommandFileName.dropLast(4))
                            .frame(height: 30)
                            .foregroundColor(mainPanelTab == MainPanelTab.sqlCommand ? .white: .gray)
                    }
                    .frame(width: 150, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )
                    .onTapGesture {
                        mainPanelTab = MainPanelTab.sqlCommand
                    }
                    
                    HStack {
                        Text("Log")
                            .foregroundColor(mainPanelTab == MainPanelTab.consoleLog ? .green: .gray)
                            .fontWeight(.bold)
                        Text("Console Log")
                            .frame(height: 30)
                            .foregroundColor(mainPanelTab == MainPanelTab.consoleLog ? .white: .gray)
                    }
                    .frame(width: 150, alignment: .leading)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )
                    .onTapGesture {
                        mainPanelTab = MainPanelTab.consoleLog
                    }
                    
                }
                .frame(height: 35)
            
                Divider()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .overlay(.black)

            CodeEditor(
                source: mainPanelTab == MainPanelTab.consoleLog ? $contentConsoleLog : $content,
                       language: mainPanelTab == MainPanelTab.unitTest ? .javascript : mainPanelTab == MainPanelTab.sqlCommand ? .sql : .tex  ,
                       theme: .default)
            }
            .onChange(of: environmentString.selectedtUnitTestFileName) {
                self.loadContentFromFile()
            }
            .onChange(of: environmentString.selectedSQLCommandFileName) {
                self.loadContentFromFile()
            }
            .onChange(of: mainPanelTab) {
                guard mainPanelTab != MainPanelTab.consoleLog else { return }
                self.loadContentFromFile()
            }
            .onChange(of: projectManagerService.selectedProjectModel.name) {
                self.loadContentFromFile()
            }
            .onChange(of: content) {
                self.saveContentToFile()
            }
    }
}

#Preview {
    MainPanelView(mainPanelTab: .constant(.unitTest))
}
