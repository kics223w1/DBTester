import Foundation
import NIO
import PostgresNIO
import PostgresClientKit
import SwiftUI

class DBTesterCore : ObservableObject {

    static let shared = DBTesterCore()
    
    @Published var isRunningTest: Bool

    init() {
        self.isRunningTest = false
    }
    
    func runAllTests(updateLog: Binding<String>, updateRunningTest: Binding<Bool>) {
        guard !isRunningTest else {
            return
        }
        
        // Dispatch the test execution to a background thread
        DispatchQueue.global(qos: .background).async {
            let fileNames = ProjectManagerService.shared.getAllUniTestFileNames()

            guard let unwrappedFileNames = fileNames else {
                    return
            }
            
            if unwrappedFileNames.isEmpty {
                return
            }
            
            ConsoleLogService.shared.addContent(value: "Start executing \(unwrappedFileNames.count) \(unwrappedFileNames.count > 1 ? "tests" :"test")", updateLog: updateLog)
            self.isRunningTest = true

            // Perform the test logic here
            for fileName in unwrappedFileNames {
                if !self.isRunningTest  {
                    return
                }
                                
                self.executeTest(unitTestName: fileName, updateLog: updateLog)
            }
            
            // Ensure the UI updates on the main thread
            DispatchQueue.main.async {
                self.isRunningTest = false
                updateRunningTest.wrappedValue = false
                
                ConsoleLogService.shared.addContent(value: "Done execute \(unwrappedFileNames.count) \(unwrappedFileNames.count > 1 ? "tests" :"test")", updateLog: updateLog)
            }
        }
    }
    
    func stopRunning() {
        self.isRunningTest = false
    }
    
    func executeTest(unitTestName: String , updateLog: Binding<String>) {
        let folderPath = ProjectManagerService.shared.getUnitTestFolderPath()
        let filePath = (folderPath.path as NSString).appendingPathComponent(unitTestName)
        
        ConsoleLogService.shared.addContent(value: "Executing \(unitTestName)", updateLog: updateLog)
        
        do {
            let script = try String(contentsOfFile: filePath, encoding: .utf8)
            JSCore.shared.executeScript(testName: unitTestName, script: script, updateLog: updateLog)
        } catch {
            ConsoleLogService.shared.addContent(value: "Executing \(unitTestName) failed due to \(error)", updateLog: updateLog)
        }
    }
    
    func executeSQLAttribute(models: [ColumnAttributeModel]) {
        do {
            guard let client = ConnectionService.shared.helper.client else { return }
                
            for model in models {
                for key in model.keys {
                    let statement = try client.prepareStatement(text: "SELECT \(key) FROM information_schema.columns WHERE table_name = '\(model.tableName)' AND column_name = '\(model.columnName)'")
       
                    defer { statement.close() }
                    
                    let cursor = try statement.execute()
                    defer { cursor.close() }
                    
                    for row in cursor {
                        let columns = try row.get().columns
                        if let firstColumn = columns.first {
                            model.appendResult(value: firstColumn)
                        } else {
                            model.appendResult(value: "undefined")
                        }
                        break
                    }
                }
            }
        } catch {
            print(error)
        }
        
       
    }
}
