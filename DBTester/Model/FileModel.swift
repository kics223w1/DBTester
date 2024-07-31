//
//  FileModel.swift
//  DBTester
//
//  Created by Cao Huy on 17/7/24.
//

import Foundation

struct FileModel {
    
    static func isUnitTest(name : String) -> Bool {
        return name.hasSuffix(".js")
    }
    
    static func createFileInFolderPath(name : String, folderPath : String) {
        let fileManager = FileManager.default
        let filePath = (folderPath as NSString).appendingPathComponent(name)
        if !fileManager.fileExists(atPath: filePath) {
            let fileContents = TemplateService.shared.getDefaultForFileModel(fileName: name)
            let fileURL = URL(fileURLWithPath: filePath)
            do {
                try fileContents.write(to: fileURL, atomically: true, encoding: .utf8)
                print("File created successfully at \(filePath)")
            } catch {
                print("Failed to create file: \(error.localizedDescription) \(filePath)")
            }
        } else {
            print("File already exists at \(filePath)")
        }
    }
}
