//
//  ConnectionFormViewModel.swift
//  DBTester
//
//  Created by Cao Huy on 21/7/24.
//

import SwiftUI
import Combine

class ConnectionFormViewModel: ObservableObject {
    @Published var name: String
    @Published var host: String
    @Published var port: String
    @Published var username: String
    @Published var password: String
    @Published var database : String
    
    let connectionService = ConnectionService()

    
    init(placeholders: [String: String]) {
        self.name = ""
        self.host = placeholders["Host"] ?? ""
        self.port = placeholders["Port"] ?? ""
        self.username = ""
        self.password = ""
        self.database = ""
    }
    
    func testConnection(selectedDatabase: Database) async -> String {
        let con = self.getConnection(selectedDatabase: selectedDatabase)
        return await connectionService.canConnect(con: con)
   }
    
    func addAndSaveConnection(selectedDatabase: Database) {
        let con = self.getConnection(selectedDatabase: selectedDatabase)
        connectionService.addNewConnection(con: con)
        connectionService.saveConnection()
    }
    
    func getConnection(selectedDatabase: Database) -> ConnectionModel {
        let con = ConnectionModel(name : self.name, host: self.host, port: self.port, username : self.username, password: self.password, databaseType: selectedDatabase, databaseName: self.database, isSelected: false)
        return con
    }
}
