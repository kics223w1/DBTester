//
//  TreeNode.swift
//  DBTester
//
//  Created by Cao Huy on 17/7/24.
//

import Foundation



struct TreeNode: Identifiable {
    let id = UUID()
    var name: String
    let isParent: Bool
    let isNewNode: Bool = false
    var children: [TreeNode]? = nil
    
    func isUnitTest() -> Bool {
        return self.name.hasSuffix(".js")
    }
    
    mutating func addNewNode(name : String) {
        let newNode = TreeNode(name: name, isParent: false)
           if var currentChildren = children {
               currentChildren.append(newNode)
               children = currentChildren
           } else {
               children = [newNode]
           }
    }
    
    static func getCorrectChildName(input: String , isUnitTest : Bool) -> String {
        if isUnitTest {
            return input.hasSuffix(".js") ? input : input + ".js"
        } else {
            return input.hasSuffix(".sql") ? input : input + ".sql"
        }
    }

    
    
 
}
