//
//  TopNavigationBar.swift
//  DBTester
//
//  Created by Cao Huy on 3/7/24.
//

import SwiftUI

struct TopNavigationBar: View {

    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var projectManagerService: ProjectManagerService

    
    @State private var isPopoverShowing = false
    
    private func openAlert() {
        alertManager.title = "New Project"
        alertManager.placeHolder = "Project 1"
        alertManager.fromWho = "TopNavigationBar"
        alertManager.isOn = true
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Text(projectManagerService.selectedProjectModel.name)
                        .font(.system(size: 16)) // Increase font size
                        .fontWeight(.bold)
                    Image(systemName: "chevron.down")
                }
                .padding()
                .frame(alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    self.isPopoverShowing = true
                }
                .popover(isPresented: self.$isPopoverShowing, arrowEdge: .bottom) {
                    VStack {
                        List(ProjectManagerService.shared.projectModels) { projectModel in
                            Button(action: {
                                projectManagerService.updateSelectedProjectModel(name: projectModel.name)
                            }) {
                                Text(projectModel.name)
                                    .padding(.vertical, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .frame(width: 200 , height: 100)
                        .background(Color.clear)
                        .border(Color.white, width: 1)
                    
                        
                        Button(action: {
                            // Handle button action
                            self.isPopoverShowing = false // Close popover
                            openAlert()
                        }) {
                            Text("New project")
                                .frame(width: 180, height: 30)
                        }
                        .padding(.top, 10) // Add margin top for the button
                       
                    }
                    .padding()
                    .cornerRadius(8)
                }
        }.onChange(of: alertManager.isOn, {
            if !alertManager.text.isEmpty && alertManager.fromWho == "TopNavigationBar" {
                projectManagerService.addNewProject(name: alertManager.text)
                alertManager.reset()
            }
        })
    }
}



#Preview {
    TopNavigationBar()
}
