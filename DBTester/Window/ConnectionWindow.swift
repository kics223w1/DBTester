import SwiftUI

struct DatabaseInfo: Hashable {
    let database: Database
    let message: String
}

struct ConnectionWindow: View {
    @State private var selectedDatabase: Database = .postgreSQL

    let databaseInfos : [DatabaseInfo] = [
        DatabaseInfo(database: .postgreSQL, message: ""),
        DatabaseInfo(database: .mySQL, message: "Added in v0.2.0"),
        DatabaseInfo(database: .sqlServer, message: "Added in v0.3.0"),
        DatabaseInfo(database: .mongodb, message: "Added in v0.4.0")
    ]

    
    var body: some View {
        NavigationView {
            VStack {
                List(databaseInfos, id: \.self, selection: $selectedDatabase) { databaseInfo in
                    HStack {
                        Image(systemName: "cylinder.split.1x2")
                            .foregroundColor(.blue)
                            .offset(y: -2)
                        
                        GeometryReader { geometry in
                            HStack {
                                Text(databaseInfo.database.friendlyName)
                                    .foregroundColor(databaseInfo.database == .postgreSQL ? .white : .gray)
                                Spacer()
                                if !databaseInfo.message.isEmpty {
                                    Text("(\(databaseInfo.message))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .frame(width: geometry.size.width)
                        }
                    }
                    .onTapGesture {
                        selectedDatabase = databaseInfo.database
                    }
                }
                
            }
            .frame(minWidth: 200)
            .listStyle(SidebarListStyle())
            
            ConnectionForm(selectedDatabase: self.$selectedDatabase)
            
        }.ignoresSafeArea()
    }
}


#Preview {
    ConnectionWindow()
}
