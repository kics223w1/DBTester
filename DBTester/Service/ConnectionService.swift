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

class ConnectionService {
    static let shared = ConnectionService()
    
    @Published var connections : [ConnectionModel]
    
    init() {
        self.connections = []
    }
    
    func getSavePath() -> URL {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let savePath = appSupportDir.appendingPathComponent("ConnectionService.json", isDirectory: false)
        return savePath
    }
    
    func addNewConnection(con : ConnectionModel) {
        self.connections.append(con)
    }
    
    func deleteConnection(con: ConnectionModel) {
        if let index = connections.firstIndex(where: { $0.id == con.id }) {
            connections.remove(at: index)
            self.saveConnection()
        } else {
            print("Connection not found.")
        }
    }
    
    func saveConnection() {
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

    func loadConnections() {
        let savePath = self.getSavePath()
        do {
            let data = try Data(contentsOf: savePath)
            let decoder = JSONDecoder()
            self.connections = try decoder.decode([ConnectionModel].self, from: data)
            print("Connections loaded successfully.")
        } catch {
            print("Failed to load connections: \(error)")
        }
    }
    
    func canConnect(con : ConnectionModel) async -> String  {
        switch con.databaseType {
        case .postgreSQL :
           return await self.testPostgreSQLConnection(con: con)
        default:
            return "Not OK"
        }
    }
        
    private func testPostgreSQLConnection(con : ConnectionModel) async -> String {
        guard let port = Int(con.port) else {
                return "Invalid port number"
        }
                
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = con.host
            configuration.port = port
            
            configuration.database = con.databaseName
            
            configuration.user = con.username
            configuration.credential = Credential.trust
            
            configuration.ssl = false

            
            let client = try PostgresClientKit.Connection(configuration: configuration)
            defer { client.close() }
            
            let text =  "SELECT 1"
            let statement = try client.prepareStatement(text: text)
            defer { statement.close() }

            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }

            
            return "OK"
        } catch {
            return "\(error)"
        }
    }
}
