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
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare"),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "11234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Namecheap"),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "21234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "GitHub"),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "31234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Google Mail"),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "41234567890".data(using: .ascii)!, digits: 6, period: 3))
]

struct ContentView: View {
    @State var accounts: [Account<TOTP>] = []
    @State private var showScanner = false

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
