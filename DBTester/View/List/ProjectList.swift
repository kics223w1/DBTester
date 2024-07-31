//
//  ProjectList.swift
//  DBTester
//
//  Created by Cao Huy on 29/7/24.
//

import SwiftUI

struct ProjectList: View {
    @Binding var isPopoverVisible : Bool

    @EnvironmentObject var projectManagerService: ProjectManagerService
    @EnvironmentObject var alertManager: AlertManager
    
    @State private var selectedProject: ProjectModel? = ProjectManagerService.shared.projectModels.first(where: {$0.isSelected})

    private func newProject() {
        alertManager.title = "New project"
        alertManager.placeHolder = "Project 1"
        alertManager.fromWho = "PopoverConnection"
        alertManager.isOn = true
    }
    
    private func openProject() {
        if let selectedProjectId = self.selectedProject?.id {
              projectManagerService.updateSelectedProjectModel(id: selectedProjectId)
          }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(projectManagerService.projectModels) { projectModel in
                    Button(action: {
                        selectedProject = projectModel
                    }) {
                        HStack {
                            Image(systemName: "cylinder.split.1x2")
                            Text(projectModel.name)
                        }
                        .frame(height: 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(selectedProject?.id == projectModel.id ? Color.green : Color.clear)
                        .cornerRadius(4)
                        .onTapGesture {
                            selectedProject = projectModel
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
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
                    newProject()
                }label: {
                     Text("New")
                        .frame(width: 60)
                }
                .buttonStyle(BorderedButtonStyle())
                
                Button {
                    openProject()
                }label: {
                    Text("Open")
                        .frame(width: 60)
                }
                .buttonStyle(BorderedButtonStyle())
            }
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    ProjectList(isPopoverVisible: .constant(false))
}
