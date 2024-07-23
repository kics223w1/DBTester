import Foundation




struct ConnectionModel: Encodable, Decodable, Identifiable {
    let id: UUID
    let name: String
    let host :String
    let port :String
    let username : String
    let password: String
    let databaseType: Database
    let databaseName: String
    let isSelected: Bool
    
    init(name : String, host: String, port: String, username : String, password: String, databaseType: Database, databaseName: String, isSelected: Bool) {
        self.id = UUID()
        self.name = name
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.databaseType = databaseType
        self.databaseName = databaseName
        self.isSelected = isSelected
    }
    
    func getDescription() -> String {
        return "Name: \(self.name) | Driver: \(self.databaseType.friendlyName) | \(self.host):\(self.port)"
    }
    
    // Custom initializer to decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString)!
        self.name = try container.decode(String.self, forKey: .name)
        self.host = try container.decode(String.self, forKey: .host)
        self.port = try container.decode(String.self, forKey: .port)
        self.username = try container.decode(String.self, forKey: .username)
        self.password = try container.decode(String.self, forKey: .password)
        self.databaseType = try container.decode(Database.self, forKey: .databaseType)
        self.databaseName = try container.decode(String.self, forKey: .databaseName)
        self.isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }

    // Encode function for encoding to JSON
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(host, forKey: .host)
        try container.encode(port, forKey: .port)
        try container.encode(username, forKey: .username)
        try container.encode(password, forKey: .password)
        try container.encode(databaseType, forKey: .databaseType)
        try container.encode(databaseName, forKey: .databaseName)
        try container.encode(isSelected, forKey: .isSelected)
    }

    
    // Define CodingKeys for the properties
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case host
        case port
        case username
        case password
        case databaseType
        case databaseName
        case isSelected
    }
}
