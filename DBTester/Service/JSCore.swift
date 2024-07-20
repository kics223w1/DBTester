import Foundation

class JSCore : ObservableObject {
    static let shared = JSCore()
    
    let projectManagerService = ProjectManagerService.shared
    
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
}
