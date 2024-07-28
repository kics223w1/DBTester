//
//  MainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 29/6/24.
//

import SwiftUI
import Combine
import CodeEditor

struct MainPanelView: View {
    @State private var content: String = ""
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var isUnitTest : Bool = true

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
        return isUnitTest ? projectManagerService.getUnitTestFilePath(fileName: environmentString.selectedTabTopMainPanelName) : projectManagerService.getSQLCommandFilePath(fileName: environmentString.selectedTabBottomMainPanelName)
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

    
    private func runTest() {
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
                            .foregroundColor(isUnitTest ? .yellow: .gray)
                            .fontWeight(.bold)
                        Text(environmentString.selectedTabTopMainPanelName.dropLast(3))
                            .frame(height: 30)
                            .foregroundColor(isUnitTest ? .white: .gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )
                    .onTapGesture {
                        isUnitTest.toggle()
                    }
                    
                    HStack {
                        Text("SQL")
                            .foregroundColor(!isUnitTest ? .green: .gray)
                            .fontWeight(.bold)
                        Text(environmentString.selectedTabBottomMainPanelName.dropLast(4))
                            .frame(height: 30)
                            .foregroundColor(!isUnitTest ? .white: .gray)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black),
                        alignment: .trailing
                    )
                    .onTapGesture {
                        isUnitTest.toggle()
                    }
                    
                }
                .frame(height: 35)
            
                Divider()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .overlay(.black)

                CodeEditor(source: $content, language: .javascript, theme: .default)
            }
            .onChange(of: environmentString.selectedTabTopMainPanelName) {
                self.loadContentFromFile()
            }
            .onChange(of: environmentString.selectedTabBottomMainPanelName) {
                self.loadContentFromFile()
            }
            .onChange(of: isUnitTest) {
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
    MainPanelView()
}
