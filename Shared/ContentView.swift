//
//  ContentView.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit
import KeychainAccess

let keychain = Keychain(service: "ch.gymni.test.otpauth")

let sampleAccounts: [Account<TOTP>] = [
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare", imageURL: URL(string: "https://cdn.dribbble.com/users/103075/screenshots/622214/dribbble-simplified-cloud.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "11234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Namecheap", imageURL: URL(string: "https://authy.com/wp-content/uploads/namecheap-logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "21234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "GitHub", imageURL: URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "31234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Google Mail", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/New_Logo_Gmail.svg/512px-New_Logo_Gmail.svg.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "41234567890".data(using: .ascii)!, digits: 6, period: 3), imageURL: URL(string: "https://i.redd.it/qupjfpl4gvoy.jpg"))
]

struct ContentView: View {
    @State var accounts: [Account<TOTP>] = sampleAccounts
    @State private var showScanner = false
    @State private var showNewAccount = false
    
    #if os(macOS)
    var body: some View {
        List {
            ForEach(accounts) { account in
                AccountView(account: account)
            }.onDelete { indexSet in
                indexSet.forEach { try? accounts[$0].remove(from: keychain) }
                accounts.remove(atOffsets: indexSet)
            }
        }
        .navigationTitle("Shiny")
        .onAppear {
            reloadAccounts()
        }
        .sheet(isPresented: $showNewAccount) {
            NewAccountView(showNewAccount: $showNewAccount, onDismiss: { reloadAccounts() })
        }
        .toolbar {
            ToolbarItem {
                Button(action: {
                    showNewAccount = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
    }
    #else
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) { account in
                    AccountView(account: account)
                }.onDelete { indexSet in
                    indexSet.forEach { try? accounts[$0].remove(from: keychain) }
                    accounts.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Shiny")
            .navigationBarItems(trailing:
                                    CircularButton(systemName: "qrcode")
                                    .padding(.top, 10)
                                    .onTapGesture {
                                        showScanner = true
                                    }).sheet(isPresented: $showScanner, onDismiss: {
                                        withAnimation {
                                            reloadAccounts()
                                        }
                                        showScanner = false
                                        
                                    }) {
                                        ScannerView(showScanner: $showScanner)
                                            .edgesIgnoringSafeArea(.bottom)
                                    }
            .onAppear {
                reloadAccounts()
            }
        }
    }
    #endif
    
    func reloadAccounts() {
        guard let keychainAccounts = try? Account<TOTP>.loadAll(from: keychain), !keychainAccounts.isEmpty else { return }
        accounts = keychainAccounts
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(accounts: sampleAccounts)
    }
}
