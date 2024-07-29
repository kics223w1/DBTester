//
//  ConnectionList.swift
//  DBTester
//
//  Created by Cao Huy on 29/7/24.
//

import SwiftUI

struct ConnectionList : View {
    @Environment(\.openWindow) private var openWindow
    
    @EnvironmentObject var connectionService: ConnectionService
    @EnvironmentObject var alertManager: AlertManager

    @Binding var isPopoverVisible : Bool
    
    @State var connectionModels : [ConnectionModel] = ConnectionService.shared.connections
    @State private var selectedConnection: ConnectionModel? = ConnectionService.shared.connections.first(where: {$0.isSelected})
    
    private func handleConnect() async {
        if let selectedConnection = self.selectedConnection {
            let message = await connectionService.canConnect(con: selectedConnection)
            if message != "OK" {
                alertManager.openErrorMessageAlert(text: message, fromWho: "ConnectionList")
            } else {
                connectionService.updateSelectedConnection(id: selectedConnection.id)
            }
        }
    }
    
    var body : some View {
        VStack {
            List {
                ForEach(connectionModels) { connectionModel in
                    HStack {
                        Image(systemName: "cylinder.split.1x2")
                        Text(connectionModel.getTitle())
                    }
                    .contentShape(Rectangle())
                    .frame(height: 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .background(selectedConnection?.id == connectionModel.id ? Color.blue : Color.clear)
                    .cornerRadius(4)
                    .onTapGesture {
                        selectedConnection = connectionModel
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.black)
                .offset(y: -8)
            
            HStack(spacing: 12) {
                Button {
                    isPopoverVisible = false
                }label: {
                     Text("Cancel")
                        .frame(width: 60)
                }
              
                .buttonStyle(BorderedButtonStyle())
                
                
                
                Spacer()
                    .frame(width: 60)
                
                Button {
                    openWindow(id: "ConnectionWindow")
                }label: {
                     Text("New")
                        .frame(width: 60)
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button {
                   
                }label: {
                    Text("Edit")
                        .frame(width: 60)
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button {
                    Task {
                        await handleConnect()
                    }
                }label: {
                    Text("Connect")
                        .frame(width: 60)
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .padding()
        }
    }
}

#Preview {
    ConnectionList(isPopoverVisible: .constant(false))
}
