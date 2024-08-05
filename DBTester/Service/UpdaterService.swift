//
//  UpdaterService.swift
//  DBTester
//
//  Created by Cao Huy on 5/8/24.
//

import Foundation

class UpdaterService : ObservableObject {
    
    static let shared = UpdaterService()
    
    @Published var newUpdate: Bool
    
    var linkDownload: String
    
    private let networkService = NetworkService()
    
    init() {
        self.newUpdate = false
        self.linkDownload = ""
    }
    
    func checkIsNewUpdate() async {
        do {
            guard let currentBuildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
                print("Failed to get current build number")
                return
            }
            let responseResult =  try await networkService.performRequest(method: "GET", endpoint: "https://dbtester-server.vercel.app/v1/version?buildNumber=\(currentBuildNumber)", body: nil)

                        
            // Assuming responseResult contains a dictionary with a key "buildNumber
            if let newUpdate = responseResult["newUpdate"] as? Bool  {
                self.newUpdate = true
        
            }
            
            if let linkDownload = responseResult["linkDownload"] as? String {
                self.linkDownload = linkDownload
            }
        } catch {
            print("Check is new udpate failed \(error)")
        }
        
    }
}
