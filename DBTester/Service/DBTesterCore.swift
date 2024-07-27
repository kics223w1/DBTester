import Foundation
import NIO
import PostgresNIO
import PostgresClientKit

class DBTesterCore : ObservableObject {

    static let shared = DBTesterCore()

    init() {
      
    }
    
    func executeSQLAttribute(models: [ColumnAttributeModel]) {
        do {
            var configuration = PostgresClientKit.ConnectionConfiguration()
            configuration.host = "localhost"
            configuration.database = "caohuy"
            configuration.user = "caohuy"
            configuration.credential = Credential.trust
            configuration.ssl = false

            let connection = try PostgresClientKit.Connection(configuration: configuration)
                
            for model in models {
                for key in model.keys {
                    let statement = try connection.prepareStatement(text: "SELECT \(key) FROM information_schema.columns WHERE table_name = '\(model.tableName)' AND column_name = '\(model.columnName)'")
       
                    defer { statement.close() }
                    
                    let cursor = try statement.execute()
                    defer { cursor.close() }
                    
                    for row in cursor {
                        let columns = try row.get().columns
                        if let firstColumn = columns.first {
                            model.appendResult(value: firstColumn)
                        } else {
                            model.appendResult(value: "undefined")
                        }
                        break
                    }
                }
            }
            
   
            
            connection.close()
        } catch {
            print(error)
        }
        
       
    }
    
    func connectDatabase() async {
       
    }

}
