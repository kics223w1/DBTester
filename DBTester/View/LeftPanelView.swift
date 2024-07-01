import SwiftUI

struct TreeNode: Identifiable {
    let id = UUID()
    var name: String
    let isParent: Bool
    let isNewNode: Bool = false
    @State var children: [TreeNode]? = nil
}

struct TreeView: View {
    @State private var isAddingNode = false
    @State private var newNodeName = ""

    @State var nodes: [TreeNode]
    
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
                    
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            .padding(.leading, 4)
        }
    }
}

struct LeftPanelView: View {
    @State private var data: [TreeNode] = [
        TreeNode(name: "Unit Test", isParent: true, children: [
            TreeNode(name: "TestTableUser.js", isParent: false),
            TreeNode(name: "TestTableProduct.js", isParent: false)
        ]),
        TreeNode(name: "SQL Command", isParent: true, children: [
            TreeNode(name: "GetUserByID.sql", isParent: false),
            TreeNode(name: "GetUserByName.sql", isParent: false)
        ])
    ]
    
    var body: some View {
        VStack {
            TreeView(nodes: data)
        }
    }
}

struct LeftPanelView_Previews: PreviewProvider {
    static var previews: some View {
        LeftPanelView()
    }
}
