//
//  PopoverProject.swift
//  DBTester
//
//  Created by Cao Huy on 20/7/24.
//

import SwiftUI

struct PopoverProject: View {
    @EnvironmentObject var projectManagerService: ProjectManagerService
    @EnvironmentObject var alertManager: AlertManager

    @Binding var isPopoverShowing: Bool
    
    private func openAlert() {
        alertManager.title = "New Project"
        alertManager.placeHolder = "Project 1"
        alertManager.fromWho = "TopNavigationBar"
        alertManager.isOn = true
    }
    
    var body: some View {
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
            .frame(width: 200, height: 100)
            .background(Color.clear)
            .border(Color.white, width: 1)

            Button(action: {
                self.isPopoverShowing = false
                openAlert()
            }) {
                Text("New project")
                    .frame(width: 180, height: 30)
            }
            .padding(.top, 10)
        }
        .padding()
        .cornerRadius(8)
    }
}

#Preview {
    PopoverProject(isPopoverShowing: .constant(false))
}
