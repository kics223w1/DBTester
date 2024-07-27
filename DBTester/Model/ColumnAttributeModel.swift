//
//  ColumnAttributeModel.swift
//  DBTester
//
//  Created by Cao Huy on 26/7/24.
//

import Foundation

class ColumnAttributeModel {
    
    var columnName : String
    var tableName : String
    var keys : [String]
    var result: [Any]
    
    init(columnName: String, tableName: String, keys: [String]) {
        self.columnName = columnName
        self.tableName = tableName
        self.keys = keys
        self.result = []
    }
    
    func appendResult(value : Any) {
        self.result.append(value)
    }
    
    func getJSObject() -> String {
        let keysString = keys.map { "\"\($0)\"" }.joined(separator: ", ")
        let resultString = result.map { "\"\($0)\"" }.joined(separator: ", ")
                
        return 
"""
        {
            keys: [\(keysString)],
            results: [\(resultString)],
            tableName: "\(self.tableName)",
            columnName: "\(self.columnName)"
        }
"""
    }
    
    static func createModels(from jsonString: String) -> [ColumnAttributeModel] {
        var columnAttributeModels = [ColumnAttributeModel]()
                
        // Parse JSON string and create ColumnAttributeModel objects
        if let jsonArray = try? JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as? [[String: Any]] {
            for item in jsonArray {
                if let columnName = item["columnName"] as? String,
                   let tableName = item["tableName"] as? String,
                   let keys = item["keys"] as? [String] {
                    
                    let columnAttributeModel = ColumnAttributeModel(columnName: columnName, tableName: tableName, keys: keys)
                    columnAttributeModels.append(columnAttributeModel)
                }
            }
        } else {
            return []
        }
        
        return columnAttributeModels
    }
    
}

