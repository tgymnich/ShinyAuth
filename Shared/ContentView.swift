//
//  ContentView.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit
import KeychainAccess

let keychain = Keychain(service: "ch.gymni.shiny-auth")

let sampleAccounts: [Account<TOTP>] = [
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare", imageURL: URL(string: "https://cdn.dribbble.com/users/103075/screenshots/622214/dribbble-simplified-cloud.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "11234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Namecheap", imageURL: URL(string: "https://authy.com/wp-content/uploads/namecheap-logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "21234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "GitHub", imageURL: URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "31234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Google Mail", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/New_Logo_Gmail.svg/512px-New_Logo_Gmail.svg.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "41234567890".data(using: .ascii)!, digits: 6, period: 3), imageURL: URL(string: "https://i.redd.it/qupjfpl4gvoy.jpg"))
]

struct ContentView: View {
    @Binding var accounts: [Account<TOTP>]
    @State private var showNewAccount = false
    
    var body: some View {
        NavigationViewWrapper {
        AccountList(accounts: $accounts)
            .navigationTitle("Shiny")
            .onAppear {
                reloadAccounts()
            }
            .sheet(isPresented: $showNewAccount) {
                reloadAccounts()
                showNewAccount = false
            } content: {
                #if os(iOS)
                ScannerView(showScanner: $showNewAccount).edgesIgnoringSafeArea(.bottom)
                #else
                NewAccountView(showNewAccount: $showNewAccount) {
                    reloadAccounts()
                }
                #endif
            }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showNewAccount = true
                    } label: {
                        #if os(iOS)
                        Image(systemName: "qrcode")
                        #else
                        Image(systemName: "plus")
                        #endif
                    }
                }
            }
        }
    }
    
    func reloadAccounts() {
        guard let keychainAccounts = try? Account<TOTP>.loadAll(from: keychain), !keychainAccounts.isEmpty else { return }
        withAnimation {
            accounts = keychainAccounts
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(accounts: .constant([]))
    }
}
