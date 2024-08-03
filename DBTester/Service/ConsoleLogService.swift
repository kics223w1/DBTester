//
//  ConsoleLogService.swift
//  DBTester
//
//  Created by Cao Huy on 1/8/24.
//

import Foundation
import SwiftUI

class ConsoleLogService : ObservableObject {
    
    static let shared = ConsoleLogService()
    
    @Published var content : String
    
    init() {
        self.content = ""
    }
    
    func addContent(value : String, updateLog: Binding<String>) {
        DispatchQueue.main.async {
            self.content = self.content + value + "\n"
            updateLog.wrappedValue = self.content
        }
    }
}
