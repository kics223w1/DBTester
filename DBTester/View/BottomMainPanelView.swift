import SwiftUI

struct BottomMainPanelView: View {
    @State private var content: String = ""
    @State private var debounceWorkItem: DispatchWorkItem?

    @EnvironmentObject var environmentString : EnvironmentString
    @EnvironmentObject var projectManagerService: ProjectManagerService

    
    private func loadContentFromFile() {
        let filePath = projectManagerService.getSQLCommandFilePath(fileName: environmentString.selectedTabBottomMainPanelName)
        
        do {
            let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
            content = fileContent
        } catch {
            print("Failed to read file: \(error.localizedDescription)")
            content = ""
        }
    }
    
    private func saveContentToFile() {
        let filePath = projectManagerService.getSQLCommandFilePath(fileName: environmentString.selectedTabBottomMainPanelName)

        do {
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print("Failed to write file: \(error.localizedDescription)")
        }
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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 0) {
                        Button(action: {
                           
                        }) {
                            Text(environmentString.selectedTabBottomMainPanelName.dropLast(4))
                                .frame(width: geometry.size.width * 0.3, height: 30)
                                .cornerRadius(0)
                        }
                        .frame(width: geometry.size.width * 0.3, height: 30)
                        .cornerRadius(0)
                        .border(Color.black,  width: 0.5)
                    }
                    .frame(width: geometry.size.width * 0.6, height: 30, alignment: .leading)
                    
                    HStack {
                        
                    }
                    .frame(width: geometry.size.width * 0.4, height: 30)
                }
                .frame(width: geometry.size.width, height: 30)
               
                
                TextEditor(text: $content)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .alignmentGuide(.leading) { _ in 0 } // Aligns VStack to the leading edge of its parent
        }
        .onChange(of: environmentString.selectedTabBottomMainPanelName) {
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

struct BottomMainPanelView_Previews: PreviewProvider {
    static var previews: some View {
        BottomMainPanelView()
    }
}
