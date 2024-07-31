//
//  ConnectionServiceHelper.swift
//  DBTester
//
//  Created by Cao Huy on 29/7/24.
//

import Foundation
import PostgresNIO
import PostgresClientKit


class ConnectionServiceHelper {
    
    var client : PostgresClientKit.Connection?
    
    func runTest() {
        
    }
    
    func connectDB(con : ConnectionModel) async -> String  {
        switch con.databaseType {
        case .postgreSQL :
           return await self.connectDBPostgreSQL(con: con)
        default:
            return "Not OK"
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
    
    private func connectDBPostgreSQL(con : ConnectionModel) async -> String {
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

            
            self.client = try PostgresClientKit.Connection(configuration: configuration)
            
            
            return "OK"
        } catch {
            self.client = nil
            return "\(error)"
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
