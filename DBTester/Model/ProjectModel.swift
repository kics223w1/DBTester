import Foundation

struct ProjectModel: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var isSelected : Bool
    
    init(name : String , isSelected : Bool) {
        self.id = UUID()
        self.name = name
        self.isSelected = isSelected
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

    static func initDefault() -> ProjectModel {
        return ProjectModel(name: "Project 1", isSelected: true)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString)!
        self.name = try container.decode(String.self, forKey: .name)
        self.isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isSelected, forKey: .isSelected)
    }

    
    enum CodingKeys: String, CodingKey {
        case id
        case savePath
        case name
        case isSelected
    }
}
