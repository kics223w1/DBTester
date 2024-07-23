//
//  PopoverConnection.swift
//  DBTester
//
//  Created by Cao Huy on 20/7/24.
//

import SwiftUI

struct PopoverConnection: View {
    @Binding var isPopoverVisible : Bool
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack {
            HStack(spacing: -10) {
                VStack(alignment: .trailing) {
                    Text("Name:")
                    Text("Driver:")
                    Text("DB name:")
                    Text("Host:")
                }
                
                VStack(alignment: .leading) {
                    Text("Connection 1")
                    Text("PostgreSQL")
                    Text("caohuy")
                    Text("caohuy")
                }
                .padding()
    
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Make the parent vifi
            .background(Color.black)

            
            Spacer()
            HStack(spacing: 10){
                
                Button {
                    
                } label: {
                     Text("Disconnect")
                }
                
                Spacer()
                
                Button {
                    openWindow(id: "ConnectionListWindow")
                } label: {
                     Text("Connection List")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // Make the parent view fi
        .padding()
    }
}

#Preview {
    PopoverConnection(isPopoverVisible: .constant(false))
}
