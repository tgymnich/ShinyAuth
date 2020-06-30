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

struct ContentView: View {
    @State var accounts: [Account] = []
    @State private var showScanner = false

    var body: some View {
        NavigationView {
            List(accounts) { account in
                AccountView(account: account)
            }
            .navigationTitle("Shiny")
            .navigationBarItems(trailing:
                                    CircularButton(systemName: "qrcode").onTapGesture {
                                        showScanner = true
                                    }).sheet(isPresented: $showScanner, onDismiss: { showScanner = false }) {
                                        ScannerView()
                                            .edgesIgnoringSafeArea(.bottom)
                                    }
            .onAppear {
                guard let keychainAccounts = try? Account.loadAll(from: keychain), !keychainAccounts.isEmpty else { return }
                accounts = keychainAccounts
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(accounts: sampleAccounts)
    }
}


let sampleAccounts: [Account] = [
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare", imageURL: nil),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "11234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Namecheap", imageURL: nil),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "21234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "GitHub", imageURL: nil),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "31234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Google Mail", imageURL: nil)
]

extension Account: Identifiable {}

struct AccountView: View {
    let account: Account
    @State private var currentCode: String = ""
    @State private var progress: CGFloat = 0.0

    var body: some View {
        HStack {
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                Text(account.issuer ?? "")
                Text(account.label)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack {
                GradientText(currentCode, colors: [.green, .blue], progress: progress)
                    .font(.title3)
                    .onAppear {
                        currentCode = account.otpGenerator.code()
                    }
                    .onReceive(TOTP.TOTPPublisher(totp: account.otpGenerator as! TOTP)) { token in
                        currentCode = token.code
                        progress = -0.99
                        withAnimation(.linear(duration: token.timeRemaining)) {
                            progress = 0.99
                        }
                    }
            }
        }
        .padding(.all)
    }
}


struct CircularButton: View {
    var systemName = "qrcode.viewfinder"
    var body: some View {
        return HStack {
            Image(systemName: systemName)
                .foregroundColor(.black)
                .imageScale(.large)
        }
        .frame(width: 44, height: 44)
        .background(Color.white)
        .cornerRadius(30)
    }
}
