import Foundation

class ConnectionFormController {
    
    func getPlaceholderObject(database: Database) -> [String: String] {
        switch database {
        case .postgreSQL:
            return [
                "Host": "localhost",
                "Port": "5432"
            ]
        case .mySQL:
            return [
                "Host": "localhost",
                "Port": "3306"
            ]
        case .mongodb:
            return [
                "Host": "localhost",
                "Port": "27017"
            ]
        case .oracle:
            return [
                "Host": "localhost",
                "Port": "1521"
            ]
        case .sqlServer:
            return [
                "Host": "localhost",
                "Port": "1433"
            ]
        default:
            return [:]
        }
    }
}
