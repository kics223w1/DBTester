import Foundation
import JavaScriptCore

class JSCore : ObservableObject {
    static let shared = JSCore()
    private let projectManagerService = ProjectManagerService.shared

    
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
       let consoleLog: @convention(block) (String) -> Void = { message in
           print("JavaScript console.log: \(message)")
       }
       self.jsContext?.objectForKeyedSubscript("console").setObject(consoleLog, forKeyedSubscript: "log" as (NSCopying & NSObjectProtocol))
    }
    
    func clearContext() {
        self.setupContext()
    }
    
    
    func executeScript(script : String) -> JSValue? {
        self.clearContext()
        
        let newScript = self.prependScriptWithClass(script: script)
        
        
        if let result = jsContext?.evaluateScript(newScript) {
            print("JavaScript Result: \(result)")
            return result
        } else {
            print("Failed to execute JavaScript code.")
            return nil
        }
    }
    
    func prependScriptWithClass(script :String) -> String {
        let classDefinition = TemplateService.shared.getAddingClass()
        return classDefinition + "\n" + script
    }
}
