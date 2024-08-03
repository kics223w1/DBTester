//
//  LicenseService.swift
//  DBTester
//
//  Created by Cao Huy on 3/8/24.
//

import Foundation

class LicenseService : ObservableObject {
    static let shared = LicenseService()
    
    @Published var isAuthorized: Bool = false
    
    private let storageService = StorageService()
    
    private let baseURL = "https://api.lemonsqueezy.com/v1/licenses"
    private let networkService = NetworkService()
    
    private let licenseKeyKey = "licenseKeyDBTesterPro1"
    private let instanceIDKey = "instanceIDDBTesterPro1"
    
    var responseValidation : [String: Any]?
    
    init() {}
    
    func setIsAuthorized(value: Bool) {
        DispatchQueue.main.async {
            self.isAuthorized = value
        }
    }
        
    func validateLicense() {
        let resultLicenseKey = storageService.loadFromKeychain(key: licenseKeyKey)
        let resultInstanceID = storageService.loadFromKeychain(key: instanceIDKey)
        
        guard let licenseKey = resultLicenseKey else {return}
        guard let instanceID = resultInstanceID else {return}

        
        let instanceName = "DBTester"
        let endpoint = "\(baseURL)/validate"
        let requestData: [String: Any] = [
            "license_key": licenseKey,
            "instance_name": instanceName,
            "instance_id" : instanceID
        ]
                
        networkService.performRequest(endpoint: endpoint, requestData: requestData, completion: {
            result in
            switch result {
            case .success(let responseJSON):
                self.responseValidation = responseJSON
                if let errorMessage = responseJSON["error"] as? String {
                    self.setIsAuthorized(value: errorMessage == "<null>")
                } else {
                    self.setIsAuthorized(value: true)
                }
            case .failure(_):
                self.setIsAuthorized(value: false)
            }
        })
    }
    
    func activateLicense(licenseKey: String , completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let instanceName = "DBTester"
        let endpoint = "\(baseURL)/activate"
        let requestData: [String: Any] = [
            "license_key": licenseKey,
            "instance_name": instanceName
        ]
        
        self.networkService.performRequest(endpoint: endpoint, requestData: requestData, completion: completion)

    }
    
    func deActivateLicense(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let resultLicenseKey = storageService.loadFromKeychain(key: licenseKeyKey)
        let resultInstanceID = storageService.loadFromKeychain(key: instanceIDKey)
        
        guard let licenseKey = resultLicenseKey else {return}
        guard let instanceID = resultInstanceID else {return}
        
        let instanceName = "DBTester"
        let endpoint = "\(baseURL)/deactivate"
        let requestData: [String: Any] = [
            "license_key": licenseKey,
            "instance_name": instanceName,
            "instance_id" : instanceID
        ]
        
        self.networkService.performRequest(endpoint: endpoint, requestData: requestData, completion: completion)

    }
    
    func storeLicenseKeyAndInstanceID(licenseKey: String, instanceID: String) {
        storageService.storeToKeychain(key: licenseKeyKey, value: licenseKey)
        storageService.storeToKeychain(key: instanceIDKey, value: instanceID)
    }
    
    
    func getCustomerEmail() -> String {
        if let responseJSON = self.responseValidation as? [String: Any],
           let metaJSON = responseJSON["meta"] as? [String: Any],
           let result = metaJSON["customer_email"] as? String {
            return result
        }
        return ""
    }
}
