//
//  ProjectManagerService.swift
//  DBTester
//
//  Created by Cao Huy on 4/7/24.
//

import Foundation

class ProjectManagerService : ObservableObject {
    static let shared = ProjectManagerService()
    
    @Published var selectedProjectModel: ProjectModel
    @Published var projectModels: [ProjectModel]
    
    private init() {
        let defaultProject = ProjectModel.initDefault()
        
        self.selectedProjectModel = defaultProject
        self.projectModels = [defaultProject]
    }
    
    func updateSelectedProjectModel(id: UUID) {
        for index in self.projectModels.indices {
            self.projectModels[index].isSelected = (self.projectModels[index].id == id)
        }
    
        if let projectModel = self.projectModels.first(where: { $0.id == id }) {
            self.selectedProjectModel = projectModel
            self.saveData()
        } else {
            print("No project found with the id \(id)")
        }
    }

    func addNewProject(name: String) {
        let newProject = ProjectModel(name: name, isSelected: false)
        self.projectModels.append(newProject)
        self.saveData()
    }

    func saveData() {
        let fileURL = getSavePath()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted // Optional: for pretty printed JSON

        do {
            let jsonProjectModels = try jsonEncoder.encode(projectModels)
                        
            // Create a dictionary to hold all encoded data
            var dataDict = [String: Any]()
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

                // Decode project models
                if let projectModelsString = jsonDict["projectModels"] as? String {
                    let jsonData = Data(projectModelsString.utf8)
                    self.projectModels = try jsonDecoder.decode([ProjectModel].self, from: jsonData)
                }
                
                if let selectedModel = self.projectModels.first(where: { $0.isSelected }) {
                    self.selectedProjectModel = selectedModel
                } else {
                    let defaultProject = ProjectModel.initDefault()
                    self.projectModels.append(defaultProject)
                    self.selectedProjectModel = defaultProject
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
    
    func getProjecetFolderPath() -> URL {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupportDir.appendingPathComponent(self.selectedProjectModel.name, isDirectory: true)
    }
    
    func getSQLCommandFolderPath() -> URL  {
        let projectDir = self.getProjecetFolderPath()
        return projectDir.appendingPathComponent("SQL Command", isDirectory: true)
    }
    
    func getUnitTestFolderPath() -> URL {
        let projectDir = self.getProjecetFolderPath()
        return projectDir.appendingPathComponent("Unit Test", isDirectory: true)
    }
    
    func getAllUniTestFileNames() -> [String]? {
        let fileManager = FileManager.default
        let folderPath = self.getUnitTestFolderPath()
        
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: folderPath.path)
            return fileNames
        } catch {
            print("Error reading directory: \(error) \(folderPath)")
            return nil
        }
    }
}
