import Foundation
import JavaScriptCore
import SwiftUI

class JSCore : ObservableObject {
    static let shared = JSCore()
    
    private let projectManagerService = ProjectManagerService.shared
    private let addingClassHandler = AddingClass()
    
    // A context for running JavaScript code
    private var jsContext: JSContext?
    
    private var currentLogs : [String]

    init() {
        self.currentLogs = []
        self.setupContext()
    }
    
    func getSQLCommands(script: String) -> [String] {
        let sqlCommandFolderPath = projectManagerService.getSQLCommandFolderPath()
        
        do {
            let fileManager = FileManager.default
            let fileURLs = try fileManager.contentsOfDirectory(at: sqlCommandFolderPath, includingPropertiesForKeys: nil)
            
            let fileNames = fileURLs.map { $0.deletingPathExtension().lastPathComponent }
            print("Files in directory: \(fileNames)")
            
            let lines = script.split(separator: "\n").map(String.init)
            var result : [String] = []
            
            for line in lines {
                for fileName in fileNames {
                    let cur = "\(fileName)()"
                    if line.contains(cur) {
                        result.append(fileName)
                    }
                }
            }
            
            return result
            
        } catch {
            print("Error fetching files from directory: \(error)")
            return []
        }
    }
    
    func setupContext() {
        // Initialize the JavaScript context
        self.jsContext = JSContext()

        // Check for errors in JavaScript execution
        self.jsContext?.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JavaScript Error: \(exc)")
            }
        }
        
        // Set up the custom console.log function
        let consoleLog: @convention(block) (JSValue) -> Void = { message in
            if let object = message.toObject() as? [String: Any] {
                // If the message is an object, convert it to JSON string
                if let data = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                   self.currentLogs.append(jsonString)
                }
            } else if let array = message.toObject() as? [Any] {
                // If the message is an array, convert it to JSON string
                if let data = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                  self.currentLogs.append(jsonString)
                }
            } else {
                self.currentLogs.append(message.toString())
            }
        }
        
        self.jsContext?.objectForKeyedSubscript("console").setObject(consoleLog, forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol))
    }

    
    func clearContext() {
        self.currentLogs = []
        self.setupContext()
    }
    
    func executeScript(testName: String ,script : String , updateLog: Binding<String>) {
        let result1 = self.executeScriptFirstTime(script: script , updateLog: updateLog)
        if let jsValue = result1 {
            
            let result2 = self.executeScriptSecondTime(script: script, jsValue: jsValue , updateLog : updateLog)
            if let jsValue2 = result2 {
                if let resultArray = jsValue2.toObject() as? [Int] {
                    let totalTests = resultArray[0]
                    let failedTests = resultArray[1]
                    
                    for log in self.currentLogs {
                        ConsoleLogService.shared.addContent(value: log, updateLog: updateLog)
                    }
                    
                    ConsoleLogService.shared.addContent(value: "\(testName) | Total: \(totalTests) tests | ✅ \(totalTests - failedTests) passed | ❌ \(failedTests) failed.", updateLog: updateLog)
                }
            }
            return
        }
        
        ConsoleLogService.shared.addContent(value: "Failed to execute test \(testName)", updateLog: updateLog)
    }
    
    private func executeScriptFirstTime(script: String ,  updateLog: Binding<String>) -> JSValue?  {
        self.clearContext()
        
        let newScript = addingClassHandler.getTopAddingScriptAtFirstTime()
                    + "\n" + script + "\n"
                    + addingClassHandler.getBottomAddingScriptAtFirstTime()
        
        if let result = jsContext?.evaluateScript(newScript) {
            return result
        } else {
            return nil
        }
    }
    
    private func executeScriptSecondTime(script : String , jsValue : JSValue , updateLog: Binding<String>) -> JSValue? {
        if jsValue.isObject {
            if let resultArray = jsValue.toObject() as? [Any],
                      let data = try? JSONSerialization.data(withJSONObject: resultArray, options: .prettyPrinted),
                      let jsonString = String(data: data, encoding: .utf8) {
                let models :[ColumnAttributeModel] = ColumnAttributeModel.createModels(from: jsonString);
                DBTesterCore.shared.executeSQLAttribute(models: models)
                
                self.clearContext()
                
                let newScript2 = addingClassHandler.getTopAddingScriptAtSecondTime(models: models)
                + "\n" + script + "\n" + addingClassHandler.getBottomAddingScriptAtSecondTime()
                                    
                return jsContext?.evaluateScript(newScript2)
            }
        }
        
        return nil
    }
    
    
}
