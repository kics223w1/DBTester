import Foundation
import JavaScriptCore

class JSCore : ObservableObject {
    static let shared = JSCore()
    
    private let projectManagerService = ProjectManagerService.shared
    private let addingClassHandler = AddingClass()
    
    // A context for running JavaScript code
    private var jsContext: JSContext?

    init() {
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
                    print("JavaScript console.log: \(jsonString)")
                } else {
                    print("JavaScript console.log: [Could not serialize object]")
                }
            } else if let array = message.toObject() as? [Any] {
                // If the message is an array, convert it to JSON string
                if let data = try? JSONSerialization.data(withJSONObject: array, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("JavaScript console.log: \(jsonString)")
                } else {
                    print("JavaScript console.log: [Could not serialize array]")
                }
            } else {
                // Otherwise, print the message directly
                print("JavaScript console.log: \(message)")
            }
        }
        
        self.jsContext?.objectForKeyedSubscript("console").setObject(consoleLog, forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol))
    }

    
    func clearContext() {
        self.setupContext()
    }
    
    func runTest(fileName: String) {
        let folderPath = projectManagerService.getUnitTestFolderPath()
        let filePath = (folderPath.path as NSString).appendingPathComponent(fileName)
        
        do {
            let script = try String(contentsOfFile: filePath, encoding: .utf8)
            if let result = executeScript(script: script) {
                print("Script executed successfully: \(result)")
            } else {
                print("Script execution returned nil")
            }
        } catch {
            print("Failed to read file: \(error) \(filePath)")
        }
    }
    
    
    func executeScript(script : String) -> JSValue? {
        self.clearContext()
        
        let newScript = addingClassHandler.getTopAddingScriptAtFirstTime()
                    + "\n" + script + "\n"
                    + addingClassHandler.getBottomAddingScriptAtFirstTime()
            
        if let result = jsContext?.evaluateScript(newScript) {
            if result.isObject {
                // If the result is an object, serialize it to JSON string
                if let resultObject = result.toObject() as? [String: Any],
                   let data = try? JSONSerialization.data(withJSONObject: resultObject, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                        
                    
                } else if let resultArray = result.toObject() as? [Any],
                          let data = try? JSONSerialization.data(withJSONObject: resultArray, options: .prettyPrinted),
                          let jsonString = String(data: data, encoding: .utf8) {
                    let models :[ColumnAttributeModel] = ColumnAttributeModel.createModels(from: jsonString);
                    DBTesterCore.shared.executeSQLAttribute(models: models)
                    
                    self.clearContext()
                    let newScript2 = addingClassHandler.getTopAddingScriptAtSecondTime(models: models)
                                + "\n" + script
                                        
                    jsContext?.evaluateScript(newScript2)
                }
            }
        } else {
            print("Failed to execute JavaScript code.")
            return nil
        }
        
        
        return nil
    }
    
    
    
}
