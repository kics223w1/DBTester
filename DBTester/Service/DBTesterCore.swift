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
            guard let client = ConnectionService.shared.helper.client else { return }
                
            for model in models {
                for key in model.keys {
                    let statement = try client.prepareStatement(text: "SELECT \(key) FROM information_schema.columns WHERE table_name = '\(model.tableName)' AND column_name = '\(model.columnName)'")
       
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
        } catch {
            print(error)
        }
        
       
    }
    
    func connectDatabase() async {
       
    }

}
