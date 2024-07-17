//
//  FileModel.swift
//  DBTester
//
//  Created by Cao Huy on 17/7/24.
//

import Foundation

struct FileModel: Identifiable, Codable {
    let id: UUID
    let name: String
    
    init(name : String, folderPath : String) {
        self.id = UUID()
        self.name = name
        self.createFileInFolderPath(folderPath: folderPath)
    }
    
    func isUnitTest() -> Bool {
        return self.name.hasSuffix(".js")
    }
    
    private func createFileInFolderPath(folderPath : String) {
        let fileManager = FileManager.default
        let filePath = (folderPath as NSString).appendingPathComponent(self.name)
        if !fileManager.fileExists(atPath: filePath) {
            let fileContents = ""
            let fileURL = URL(fileURLWithPath: filePath)
            do {
                try fileContents.write(to: fileURL, atomically: true, encoding: .utf8)
                print("File created successfully at \(filePath)")
            } catch {
                print("Failed to create file: \(error.localizedDescription)")
            }
        } else {
            print("File already exists at \(filePath)")
        }
    }
}
