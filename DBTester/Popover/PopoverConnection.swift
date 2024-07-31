//
//  PopoverConnection.swift
//  DBTester
//
//  Created by Cao Huy on 20/7/24.
//

import SwiftUI

struct PopoverConnection: View {
    @Binding var isPopoverVisible : Bool
    
    @EnvironmentObject var projectManagerService: ProjectManagerService
    
    @State var isConnectionListVisible : Bool = true
        
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                HStack {
                    Text("Connection")
                }
                .frame(width: 100)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isConnectionListVisible ? Color(red: 55/255, green: 55/255, blue: 53/255) : Color.clear)
                .overlay(
                    VStack {
                        Rectangle()
                            .frame(height: 1) // Top border
                            .foregroundColor(.black)
                        Spacer()
                        Rectangle()
                            .frame(height: 1) // Bottom border (we'll hide this)
                            .foregroundColor(.clear)
                    }
                )
                .overlay(
                    HStack {
                        Rectangle()
                            .frame(width: 1) // Left border
                            .foregroundColor(.black)
                        Spacer()
                        Rectangle()
                            .frame(width: 1) // Right border (we'll hide this)
                            .foregroundColor(.clear)
                    }
                )
                .onTapGesture {
                    isConnectionListVisible = true
                }
                
                
                HStack {
                    Text("Project")
                }
                .frame(width: 100)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(!isConnectionListVisible ? Color(red: 55/255, green: 55/255, blue: 53/255) : Color.clear)
                .overlay(
                    VStack {
                        Rectangle()
                            .frame(height: 1) // Top border
                            .foregroundColor(.black)
                        Spacer()
                        Rectangle()
                            .frame(height: 1) // Bottom border (we'll hide this)
                            .foregroundColor(.clear)
                    }
                )
                .overlay(
                    HStack {
                        Rectangle()
                            .frame(width: 1) // Left border
                            .foregroundColor(.black)
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.black)
                    }
                )
                .onTapGesture {
                    isConnectionListVisible = false
                }
            }
            .frame(height: 35)
            .offset(y: 22)
            
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.black)
                .offset(y: 8)
            
            VStack {
                if isConnectionListVisible {
                    ConnectionList(isPopoverVisible: $isPopoverVisible)
                } else {
                    ProjectList(isPopoverVisible: $isPopoverVisible)
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(Color.clear)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) 
    }
}

#Preview {
    PopoverConnection(isPopoverVisible: .constant(false))
}
