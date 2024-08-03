//
//  BuyDBTesterProWindow.swift
//  DBTester
//
//  Created by Cao Huy on 2/8/24.
//

import SwiftUI
import AppKit
import Foundation

struct BuyDBTesterProWindow: View {
    @State var isFreeVersion : Bool = false
    @EnvironmentObject var licenseService : LicenseService

    
    var body: some View {
        VStack() {
            if isFreeVersion {
                NoLicenseView(isFreeVersion: $isFreeVersion)
            } else {
                ActivatedLicenseView(isFreeVersion: $isFreeVersion)
            }
        }
        .padding()
        .onAppear{
            isFreeVersion = !licenseService.isAuthorized
        }
        .onChange(of: licenseService.isAuthorized) {
            isFreeVersion = !licenseService.isAuthorized
        }
    }
}

struct ComparisonTableRow: View {
    var content : String
    var isFree: Bool
    
    var body: some View {
        HStack {
            Text(content)
                .fontWeight(.regular)
                .font(.system(size: 14))
                .foregroundColor(.white)
            
            Spacer()
            
            if isFree {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.green)
                    .offset(x: -40)
            } else {
                Divider()
                    .frame(width: 12, height: 2)
                    .background(Color.white)
                    .offset(x: -40)
            }
            
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.green)
                .offset(x: -4)
                
        }
    }
}


struct ActivatedLicenseView : View {
    @State var isLoading : Bool = false
    @State var message : String = ""
    
    @Binding var isFreeVersion: Bool
    
    private func deActivateLicense() {
        message = ""
        isLoading = true
        
        LicenseService.shared.deActivateLicense { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let responseJSON):
                    if let errorMessage = responseJSON["error"] as? String {
                       message = errorMessage
                    } else {
                        message = "Successfully activate license key. Thank you for purchasing DBTester"
                        LicenseService.shared.setIsAuthorized(value: false)
                        isFreeVersion = true
                    }
                case .failure(let error):
                    message = "\(error)"
                }
            }
        }
    }
    
    var body : some View {
        VStack {
            Text("Thank you for purchasing DBTester Pro")
                .font(.system(size: 20, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Features")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    
                Spacer()
                
                
                Text("FREE")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding()
                
                Text("PRO")
                    .font(.body)
                    .fontWeight(.bold)
            }
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.gray)
                .offset(y: -20)
            
            VStack(spacing: 8) {
                ComparisonTableRow(content: "Unlimited unit tests", isFree: false)
                ComparisonTableRow(content: "Unlimited connections", isFree: false)
                ComparisonTableRow(content: "Unlimited projects", isFree: false)
                ComparisonTableRow(content: "And more...", isFree: false)
            }
            .offset(y: -12)

            Spacer()
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.gray)
        
            Text(message)
                .foregroundColor(message.starts(with: "Successfully") ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 12)
            
            HStack(spacing: 20) {
                
                Spacer()
                
                Button {
                    deActivateLicense()
                } label: {
                    Text(isLoading ? "Loading..." : "Unlink this device")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(isLoading)
            }
            .padding(.top, 2)
        }
        .padding()
    }
}

struct NoLicenseView : View {
    @State private var licenseKey: String = ""
    @State private var message : String = ""
    @State private var isLoadingActivate : Bool = false
    
    @Binding var isFreeVersion : Bool
    
    @EnvironmentObject var licenseService : LicenseService
    
    private func activateLicense() {
        message = ""
        
        if licenseKey.isEmpty {
            message = "Please enter license key"
            return
        }
        
        isLoadingActivate = true
        
        LicenseService.shared.activateLicense(licenseKey: licenseKey) { result in
            DispatchQueue.main.async {
                isLoadingActivate = false
                
                switch result {
                case .success(let responseJSON):
                    if let errorMessage = responseJSON["error"] as? String {
                       message = errorMessage
                    } else {
                        message = "Successfully activate license key. Thank you for purchasing DBTester"
                        
                        LicenseService.shared.setIsAuthorized(value: true)
                        isFreeVersion = false
                        
                        if let instanceDict = responseJSON["instance"] as? [String: Any] {
                            if let instanceID = instanceDict["id"] as? String {
                                LicenseService.shared.storeLicenseKeyAndInstanceID(licenseKey: licenseKey, instanceID: instanceID)
                            }
                        }
                    }
                case .failure(let error):
                    message = "\(error)"
                }
            }
        }
    }
    
    var body : some View {
        VStack {
            HStack {
                Text("Features")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    
                Spacer()
                
                
                Text("FREE")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding()
                
                Text("PRO")
                    .font(.body)
                    .fontWeight(.bold)
            }
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.gray)
                .offset(y: -20)
            
            VStack(spacing: 8) {
                ComparisonTableRow(content: "Unlimited unit tests", isFree: false)
                ComparisonTableRow(content: "Unlimited connections", isFree: false)
                ComparisonTableRow(content: "Unlimited projects", isFree: false)
                ComparisonTableRow(content: "And more...", isFree: false)
            }
            .offset(y: -12)

            Spacer()
            
            Divider()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .overlay(.gray)
            
            TextField(
                "XXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX",
                text: $licenseKey
            )
            .disableAutocorrection(true)
            
            Text(message)
                .foregroundColor(message.starts(with: "Successfully") ? .green : .red)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 12)
            
            HStack(spacing: 20) {
                Button {
                    
                } label: {
                    Text("Buy License...")
                }
                
                Spacer()
                
                Button {
                    activateLicense()
                } label: {
                    Text(isLoadingActivate ? "Loading..." : "Activate License")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .disabled(isLoadingActivate)
            }
            .padding(.top, 2)
        }
        .padding()
    }
}


struct BuyDBTesterProWindow_Previews: PreviewProvider {
    static var previews: some View {
        BuyDBTesterProWindow()
    }
}
