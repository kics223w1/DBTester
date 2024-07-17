import SwiftUI

struct TreeNode: Identifiable {
    let id = UUID()
    var name: String
    let isParent: Bool
    let isNewNode: Bool = false
    var children: [TreeNode]? = nil
    
    mutating func addNewNode(name : String) {
        let newNode = TreeNode(name: self.getCorrectChildName(input: name), isParent: false)
           if var currentChildren = children {
               currentChildren.append(newNode)
               children = currentChildren
           } else {
               children = [newNode]
           }
    }
    
    private func getCorrectChildName(input: String) -> String {
        if self.name == "Unit Test" {
            return input.hasSuffix(".js") ? input : input + ".js"
        } else {
            return input.hasSuffix(".sql") ? input : input + ".sql"
        }
    }

 
}

struct TreeView: View {
    @State private var isAddingNode = false
    @State private var newNodeName = ""
    
    @State private var isFromUnitTestParent = false
    
    @EnvironmentObject var alertManager: AlertManager

    
    @State private var nodes: [TreeNode] = [
           TreeNode(name: "Unit Test", isParent: true, children: [
               TreeNode(name: "TestTableUser.js", isParent: false),
               TreeNode(name: "TestTableProduct.js", isParent: false)
           ]),
           TreeNode(name: "SQL Command", isParent: true, children: [
               TreeNode(name: "GetUserByID.sql", isParent: false),
               TreeNode(name: "GetUserByName.sql", isParent: false)
           ])
       ]

    private func addNewNode(name: String) {
        if isFromUnitTestParent {
            nodes[0].addNewNode(name: name)
        } else {
            nodes[1].addNewNode(name: name)
        }
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
                    Image(systemName: "doc.text")
                        .foregroundColor(.yellow)
                } else if node.name.hasSuffix(".sql") {
                    Image(systemName: "doc.richtext")
                        .foregroundColor(.blue)
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
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.leading, 4)
        }.onChange(of: alertManager.isOn) {
            if !alertManager.text.isEmpty && alertManager.fromWho == "LeftPanelView" {
                addNewNode(name: alertManager.text)
                alertManager.reset()
            }
        }
    }
    
    
    
}

struct LeftPanelView: View {
    @State private var isHistoryVisible : Bool = false
    
    
    var body: some View {
        VStack {
            HStack(spacing: 25) {
                Text("Treeview")
                    .foregroundColor(!isHistoryVisible ? Color.white : Color.gray)
                    .onTapGesture {
                        isHistoryVisible.toggle()
                    }
                    
                
                Text("History")
                    .foregroundColor(isHistoryVisible ? Color.white : Color.gray)
                    .onTapGesture {
                        isHistoryVisible.toggle()
                    }
            
            }
            .frame(height: 20)
            
            
            TreeView()
        }
    }
}

struct LeftPanelView_Previews: PreviewProvider {
    static var previews: some View {
        LeftPanelView()
    }
}
