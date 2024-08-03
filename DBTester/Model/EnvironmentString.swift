//
//  EnvironmentString.swift
//  DBTester
//
//  Created by Cao Huy on 17/7/24.
//

import Foundation


class EnvironmentString: ObservableObject {
    @Published var selectedtUnitTestFileName : String = ""
    @Published var selectedSQLCommandFileName : String = ""
    
    func updateUnitTestFileName(fileName: String) {
        DispatchQueue.main.async {
            self.selectedtUnitTestFileName = fileName
        }
    }
    
    func updateSQLCommandFileName(fileName: String) {
        DispatchQueue.main.async {
            self.selectedSQLCommandFileName = fileName
        }
    }
}
