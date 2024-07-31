//
//  ConnectionService.swift
//  DBTester
//
//  Created by Cao Huy on 21/7/24.
//

import Foundation
import PostgresNIO
import PostgresClientKit


enum Database : Codable {
    case postgreSQL
    case mySQL
    case sqlite
    case mongodb
    case oracle
    case sqlServer
    
    var friendlyName: String {
            switch self {
            case .postgreSQL:
                return "PostgreSQL"
            case .mySQL:
                return "MySQL"
            case .sqlite:
                return "SQLite"
            case .mongodb:
                return "MongoDB"
            case .oracle:
                return "Oracle"
            case .sqlServer:
                return "SQL Server"
            }
        }
}

class ConnectionService : ObservableObject {
    static let shared = ConnectionService()
    
    @Published var connections : [ConnectionModel]
    
    var helper: ConnectionServiceHelper
    
    init() {
        self.connections = []
        self.helper = ConnectionServiceHelper()
    }
    
    func getSavePath() -> URL {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let savePath = appSupportDir.appendingPathComponent("ConnectionService.json", isDirectory: false)
        return savePath
    }
    
    func updateSelectedConnection(id: UUID) async -> String {
        guard let selectedConnection = self.connections.first(where: {$0.id == id}) else { return "Not found!" }
        
        let message = await self.helper.canConnect(con: selectedConnection)
        if message != "OK" {
            return message
        }
        
        for index in self.connections.indices {
            self.connections[index].isSelected = (self.connections[index].id == id)
        }
        
        await self.helper.connectDB(con: selectedConnection)
        self.saveConnections()
        
        return "OK"
    }
    
    func addNewConnection(con : ConnectionModel) {
        self.connections.append(con)
    }
    
    func deleteConnection(con: ConnectionModel) {
        if let index = connections.firstIndex(where: { $0.id == con.id }) {
            connections.remove(at: index)
            self.saveConnections()
        } else {
            print("Connection not found.")
        }
    }
    
    func saveConnections() {
        let savePath = self.getSavePath()
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            
            let jsonData = try jsonEncoder.encode(self.connections)
            try jsonData.write(to: savePath, options: .atomic)
            print("Connections saved successfully.")
        } catch {
            print("Failed to save connections: \(error)")
        }
    }

    func loadConnections() async {
        let savePath = self.getSavePath()
        do {
            let data = try Data(contentsOf: savePath)
            let decoder = JSONDecoder()
            self.connections = try decoder.decode([ConnectionModel].self, from: data)
            print("Connections loaded successfully. \(self.connections)")
            
            if let selectedConnection = self.connections.first(where: { $0.isSelected }) {
                await self.updateSelectedConnection(id: selectedConnection.id)
            }
        } catch {
            print("Failed to load connections: \(error)")
        }
    }
    
    func getSelectedTitle() async -> String {
        if let selectedConnection = self.connections.first(where: { $0.isSelected }) {
            let testConnectionMessage = await self.helper.canConnect(con: selectedConnection)
            return testConnectionMessage == "OK" ? selectedConnection.getTitle() : "Error! Tap to reconnect..."
        } else {
            return "Tap to create connection..."
        }
    }
    
    
}
