//
//  TreeView.swift
//  DBTester
//
//  Created by Cao Huy on 17/7/24.
//

import SwiftUI




struct TreeView: View {
    @State private var isAddingNode = false
    @State private var newNodeName = ""
    
    @State private var isFromUnitTestParent = false
    
    @EnvironmentObject var alertManager: AlertManager
    @EnvironmentObject var projectManagerService: ProjectManagerService
    @EnvironmentObject var environmentString : EnvironmentString
    
    @State private var nodes: [TreeNode] = []
    @State private var selectedNode : TreeNode?
    
    private func loadNodes() -> [TreeNode] {
        let projectName = projectManagerService.selectedProjectModel.name
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let projectDir = appSupportDir.appendingPathComponent(projectName, isDirectory: true)
        
        let unitTestDir =  projectDir.appendingPathComponent("Unit Test", isDirectory: true)
        let sqlCommandDir =  projectDir.appendingPathComponent("SQl Command", isDirectory: true)
        
        var treeNodeUnitTest = TreeNode(name : "Unit Test" , isParent: true, children: [])
        var treeNodeSQLCommand = TreeNode(name : "SQL Command" , isParent: true, children: [])

        var selectedTopPanelNode: TreeNode?
        var selectedBottomPanelNode : TreeNode?
        
        do {
            // Read files from unitTestDir
            let unitTestFiles = try FileManager.default.contentsOfDirectory(at: unitTestDir, includingPropertiesForKeys: nil)
            for file in unitTestFiles {
                if file.pathExtension == "js" { // Assuming text files, change if different
                    let treeNode1 = TreeNode(name :file.lastPathComponent, isParent: false)
                    treeNodeUnitTest.children?.append(treeNode1)
                    
                    if selectedTopPanelNode == nil {
                        selectedTopPanelNode = treeNode1
                    }
                }
            }
            
            // Read files from sqlCommandDir
            let sqlCommandFiles = try FileManager.default.contentsOfDirectory(at: sqlCommandDir, includingPropertiesForKeys: nil)
            for file in sqlCommandFiles {
                if file.pathExtension == "sql" { // Assuming SQL files, change if different
                    let treeNode1 = TreeNode(name :file.lastPathComponent, isParent: false)
                    treeNodeSQLCommand.children?.append(treeNode1)
                    
                    
                    if selectedBottomPanelNode == nil {
                        selectedBottomPanelNode = treeNode1
                    }
                }
            }
            
            environmentString.selectedtUnitTestFileName = selectedTopPanelNode?.name ?? ""
            environmentString.selectedSQLCommandFileName = selectedBottomPanelNode?.name ?? ""
            selectedNode = selectedTopPanelNode ?? selectedBottomPanelNode
            
            return [treeNodeUnitTest, treeNodeSQLCommand]
            
        } catch {
            print("Error reading files: \(error.localizedDescription)")
            
            return []
        }
    }
    
    private func addNewNode(name: String) {
        let validName = TreeNode.getCorrectChildName(input: name, isUnitTest: isFromUnitTestParent)
        let folderPath = isFromUnitTestParent ? projectManagerService.getUnitTestFolderPath() : projectManagerService.getSQLCommandFolderPath()

        
        if isFromUnitTestParent {
            nodes[0].addNewNode(name: validName)
        } else {
            nodes[1].addNewNode(name: validName)
        }
        
        FileModel.createFileInFolderPath(name: validName, folderPath: folderPath.path)
    }
    
    private func openAlert(node: TreeNode) {
        isFromUnitTestParent = node.name == "Unit Test"
        alertManager.title = isFromUnitTestParent ? "New unit test" : "New SQL comand"
        alertManager.placeHolder = isFromUnitTestParent ? "TestTableCustomer.js" : "GetUserByID.sql"
        alertManager.fromWho = "LeftPanelView"
        alertManager.isOn = true
    }
    
    var body: some View {
        List(nodes, children: \.children) { node in
            HStack {
                if node.isParent {
                    Image(systemName: "folder")
                        .padding(.trailing, 8)
                } else if node.name.hasSuffix(".js") {
                    Text("JS")
                        .foregroundColor(.green)
                } else if node.name.hasSuffix(".sql") {
                    Text("SQL")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "questionmark")
                        .foregroundColor(.gray)
                }
                
                
                Text(node.name)
                    .padding(.leading, node.isParent ? -8 : 0)
                Spacer()
                if node.isParent {
                    Button(action: {
                        openAlert(node: node)
                    }) {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 4)
            .padding(.vertical, 4)
            .background(selectedNode?.id == node.id ? Color.primary.opacity(0.1) : Color.clear) // Change background color
            .cornerRadius(5)
            .onTapGesture {
                if !node.isParent {
                    selectedNode = node
                    if node.isUnitTest() {
                        environmentString.selectedtUnitTestFileName = node.name
                    } else {
                        environmentString.selectedSQLCommandFileName = node.name
                    }
                }
            }
        }
        .onChange(of: alertManager.isOn) {
            if !alertManager.text.isEmpty && alertManager.fromWho == "LeftPanelView" {
                addNewNode(name: alertManager.text)
                alertManager.reset()
            }
        }
        .onChange(of: projectManagerService.selectedProjectModel.name) {
            self.nodes = loadNodes()
        }
        .onAppear {
            self.nodes = loadNodes()
        }
    }
    
    
    
}

#Preview {
    TreeView()
}
