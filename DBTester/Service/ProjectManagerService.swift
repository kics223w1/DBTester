//
//  ProjectManagerService.swift
//  DBTester
//
//  Created by Cao Huy on 4/7/24.
//

import Foundation

class ProjectManagerService : ObservableObject {
    static let shared = ProjectManagerService()
    
    @Published var selectedConnectionModel: ConnectionModel
    @Published var selectedProjectModel: ProjectModel
    @Published var projectModels: [ProjectModel]
    
    private init() {
        let defaultProject = ProjectModel.initDefault()
        
        self.selectedConnectionModel = ConnectionModel.initDefault()
        self.selectedProjectModel = defaultProject
        self.projectModels = [defaultProject]
    }
    
    func updateSelectedProjectModel(name: String) {
        if let projectModel = self.projectModels.first(where: { $0.name == name }) {
            self.selectedProjectModel = projectModel
            self.saveData()
        } else {
            // Handle case where no project with the given name is found
            print("No project found with the name \(name)")
        }
    }

    func addNewProject(name: String) {
        let newProject = ProjectModel(name: name)
        self.projectModels.append(newProject)
        self.saveData()
    }

    func saveData() {
        let fileURL = getSavePath()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted // Optional: for pretty printed JSON

        do {
            // Encode the selected models
            let jsonSelectedProjectModel = try jsonEncoder.encode(selectedProjectModel)
            let jsonSelectedConnectionModel = try jsonEncoder.encode(selectedConnectionModel)
            let jsonProjectModels = try jsonEncoder.encode(projectModels)

            // Convert to string for debugging (optional)
            let jsonSelectedProjectModelString = String(data: jsonSelectedProjectModel, encoding: .utf8)
            let jsonSelectedConnectionModelString = String(data: jsonSelectedConnectionModel, encoding: .utf8)
            let jsonProjectModelsString = String(data: jsonProjectModels, encoding: .utf8)
            
            print("Encoded selected project model: \(jsonSelectedProjectModelString ?? "")")
            print("Encoded selected connection model: \(jsonSelectedConnectionModelString ?? "")")
            print("Encoded project models: \(jsonProjectModelsString ?? "")")
            
            // Create a dictionary to hold all encoded data
            var dataDict = [String: Any]()
            dataDict["selectedConnectionModel"] = String(data: jsonSelectedConnectionModel, encoding: .utf8)!
            dataDict["selectedProjectModel"] = String(data: jsonSelectedProjectModel, encoding: .utf8)!
            dataDict["projectModels"] = String(data: jsonProjectModels, encoding: .utf8)!
            
            // Convert dictionary to JSON data
            let jsonData = try JSONSerialization.data(withJSONObject: dataDict, options: .prettyPrinted)
            
            // Write JSON data to file
            try jsonData.write(to: fileURL, options: .atomic)

        } catch {
            print("Error saving data: \(error)")
        }
    }

    func loadDataAtLaunch() {
        let fileURL = getSavePath()
        let jsonDecoder = JSONDecoder()
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the data into a dictionary
            if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                // Decode selected connection model
                if let selectedConnectionModelString = jsonDict["selectedConnectionModel"] as? String {
                    let jsonData = Data(selectedConnectionModelString.utf8)
                    self.selectedConnectionModel = try jsonDecoder.decode(ConnectionModel.self, from: jsonData)
                }
                
                // Decode selected project model
                if let selectedProjectModelString = jsonDict["selectedProjectModel"] as? String {
                    let jsonData = Data(selectedProjectModelString.utf8)
                    self.selectedProjectModel = try jsonDecoder.decode(ProjectModel.self, from: jsonData)
                }

                // Decode project models
                if let projectModelsString = jsonDict["projectModels"] as? String {
                    let jsonData = Data(projectModelsString.utf8)
                    self.projectModels = try jsonDecoder.decode([ProjectModel].self, from: jsonData)
                }
            }

        } catch {
            print("Error loading data: \(error)")
            
            // Init file
            self.saveData()
        }
    }

    func getSavePath() -> URL {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let savePath = appSupportDir.appendingPathComponent("DBTesterConfiguration.json", isDirectory: false)
    
        return savePath
    }
    
    func getUnitTestFilePath(fileName : String) -> String {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let projectDir = appSupportDir.appendingPathComponent(self.selectedProjectModel.name, isDirectory: true)
        let unitTestDir =  projectDir.appendingPathComponent("Unit Test", isDirectory: true)
        let filePath = unitTestDir.appendingPathComponent(fileName)

        return filePath.path
    }
    
    func getSQLCommandFilePath(fileName : String) -> String {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let projectDir = appSupportDir.appendingPathComponent(self.selectedProjectModel.name, isDirectory: true)
        let sqlCommandDir =  projectDir.appendingPathComponent("SQl Command", isDirectory: true)
        let filePath = sqlCommandDir.appendingPathComponent(fileName)

        return filePath.path
    }
}
