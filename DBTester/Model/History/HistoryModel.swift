//
//  HistoryModel.swift
//  DBTester
//
//  Created by Cao Huy on 31/7/24.
//

import Foundation

struct HistoryModel {
    var id: UUID
    var name: String
    var createdAt: Int
    var description: String?
    var logs: String
    
    init(name: String, logs: String) {
        self.id = UUID()
        self.name = name
        self.createdAt = Int(Date().timeIntervalSince1970)
        self.logs = logs
    }
    
    mutating func updateLogs(newLogs: String) {
        self.logs = newLogs
    }
    
    static func initWithRunAll() -> HistoryModel {
        return HistoryModel(name: "", logs: "")
    }
}
