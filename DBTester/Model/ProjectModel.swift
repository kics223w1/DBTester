import Foundation

struct ProjectModel: Identifiable, Codable {
    let id: UUID
    let name: String
    
    init(name : String) {
        self.id = UUID()
        self.name = name
        self.createFolder(projectName: name)
    }

    
    // Create save path for a project
    private func createFolder(projectName: String){
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let projectDir = appSupportDir.appendingPathComponent(projectName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: projectDir, withIntermediateDirectories: true, attributes: nil)
            
            let unitTestDir =  projectDir.appendingPathComponent("Unit Test", isDirectory: true)
            let sqlCommandDir =  projectDir.appendingPathComponent("SQl Command", isDirectory: true)
            
            try FileManager.default.createDirectory(at: unitTestDir, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(at: sqlCommandDir, withIntermediateDirectories: true, attributes: nil)

            FileModel.createFileInFolderPath(name: "TestTableEmployees.js" , folderPath: unitTestDir.path)
            FileModel.createFileInFolderPath(name: "GetUserByID.sql" , folderPath: sqlCommandDir.path)
            
        } catch {
            fatalError("Failed to create directory: \(error.localizedDescription)")
        }
    }

    // Default initializer
    static func initDefault() -> ProjectModel {
        return ProjectModel(name: "Project 1")
    }
    
    
    // Custom initializer to decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString)!
        self.name = try container.decode(String.self, forKey: .name)
    }

    // Encode function for encoding to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case savePath
        case name
    }
}
