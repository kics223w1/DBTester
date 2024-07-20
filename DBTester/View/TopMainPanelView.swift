//
//  TopMainPanelView.swift
//  DBTester
//
//  Created by Cao Huy on 2/7/24.
//

import SwiftUI
import Combine

struct TopMainPanelView: View {
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
        let comamnds2 : [String] = jsCore.getSQLCommands(script: content)
        print("comamnd: \(comamnds2)")
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
        VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Button(action: {
                        isUnitTest.toggle()
                    }) {
                        Text("JS")
                            .foregroundColor(.yellow)
                            .fontWeight(.bold)
                        Text(environmentString.selectedTabTopMainPanelName.dropLast(3))
                            .frame(height: 30)
                            
                    }
                    .background(
                        isUnitTest ? Color(red: 0.2, green: 0.2, blue: 0.2) : Color.black
                    )
                    
                    Button(action: {
                        isUnitTest.toggle()
                    }) {
                        Text("SQL")
                            .foregroundColor(.green)
                            .fontWeight(.bold)
                        Text(environmentString.selectedTabBottomMainPanelName.dropLast(4))
                            .frame(height: 30)

                    }
                    .background(
                        !isUnitTest ? Color(red: 0.2, green: 0.2, blue: 0.2): Color.black
                    )
                    
                    
                    Button {
                        self.runTest()
                    } label: {
                        Text("Run test")
                    }
                    .frame(minHeight: 35)
                    .buttonStyle(.borderedProminent)
                    .padding(.leading, 100)
                    
                    Button {
                        self.openFolderInVSCode()
                    } label: {
                        Text("Edit in VSCode")
                    }
                    .frame(minHeight: 35)
               
                }
                .frame(height: 30)

                // Text editor for the selected tab
                TextEditor(text: $content)
            }
            .ignoresSafeArea()
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
    TopMainPanelView()
}
