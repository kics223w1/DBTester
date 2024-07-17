import Foundation

enum ConnectionType: String, Codable {
    case mysql = "MySQL"
    case postgresql = "PostgreSQL"
}

struct ConnectionModel: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: ConnectionType
    
    init(id: UUID, name: String, type: ConnectionType) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    // Decodable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString)!
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(ConnectionType.self, forKey: .type)
    }
    
    // Encodable method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
    }
    
    // CodingKeys enumeration
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
    }
    
    // Default initializer
    static func initDefault() -> ConnectionModel {
        return ConnectionModel(id: UUID(), name: "Connection 1", type: .postgresql)
    }
}
