//
//  ConnectionListWindow.swift
//  DBTester
//
//  Created by Cao Huy on 23/7/24.
//

import SwiftUI

struct ConnectionListWindow: View {
    @Environment(\.openWindow) private var openWindow
    
    @State var connections: [ConnectionModel] = []
    @State private var selectedConnection: ConnectionModel? // State for tracking the selected connection
    
    init(connections: [ConnectionModel]) {
        self.connections = connections
    }

    var body: some View {
        VStack {
            List(connections) { connection in
                HStack {
                    Image(systemName: "cylinder.split.1x2")
                        .foregroundColor(.blue)
                        .offset(y: -2)
                    Text(connection.getDescription())
                        .foregroundColor(Color.white)
                }
                .padding()
                .cornerRadius(8)
                .onTapGesture {
                    selectedConnection = connection
                }
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    
                }label: {
                     Text("Delete")
                }
                .disabled(selectedConnection == nil)
                
                Spacer()
                
                Button {
                    
                }label: {
                     Text("Edit")
                }
                .disabled(selectedConnection == nil)
                
                Button {
                    openWindow(id: "ConnectionWindow")
                }label: {
                     Text("New")
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .padding()
            
            
        }
        .background(Color.clear)
        .frame(width: 300, height: 500)
        .padding()
        
    }
    
    private func deleteSelectedConnection() {
        if let selectedConnection = selectedConnection {
            ConnectionService.shared.deleteConnection(con: selectedConnection)
            if let index = connections.firstIndex(where: { $0.id == selectedConnection.id }) {
                connections.remove(at: index)
            }
        }
    }
}

#Preview {
    ConnectionListWindow(connections: [])
}
