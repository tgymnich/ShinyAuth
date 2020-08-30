//
//  ViewModel.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 26.08.20.
//

import Foundation
import OTPKit
import KeychainAccess

let keychain = Keychain(service: "ch.gymni.Test.ShinyAuth")
    .synchronizable(true)
    .accessibility(.afterFirstUnlock)

let sampleAccounts: [Account<TOTP>] = [
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare", imageURL: URL(string: "https://cdn.dribbble.com/users/103075/screenshots/622214/dribbble-simplified-cloud.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "11234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Namecheap", imageURL: URL(string: "https://authy.com/wp-content/uploads/namecheap-logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "21234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "GitHub", imageURL: URL(string: "https://github.githubassets.com/images/modules/logos_page/GitHub-Logo.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "31234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Google Mail", imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/New_Logo_Gmail.svg/512px-New_Logo_Gmail.svg.png")),
    Account(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "41234567890".data(using: .ascii)!, digits: 6, period: 3), imageURL: URL(string: "https://i.redd.it/qupjfpl4gvoy.jpg"))
]


final class ViewModel: ObservableObject {
    @Published private(set)var error: Error?
    @Published private(set)var accounts: [Account<TOTP>] = []
    
    private let accountProvider: () throws -> [Account<TOTP>]
    
    init() {
        accountProvider = ViewModel.loadAccountsFromKeychain
        reloadAccounts()
    }
    
    init(accounts: [Account<TOTP>]) {
        self.accountProvider = { return accounts }
        reloadAccounts()
    }
    
    func addAccount(url: URL) {
        do {
            let account = try Account<TOTP>(from: url)
            try account.save(to: keychain)
            accounts.append(account)
        } catch let error {
            self.error = error
        }
    }
    
    func addAccount(_ account: Account<TOTP>) {
        do {
            try account.save(to: keychain)
            accounts.append(account)
        } catch let error {
            self.error = error
        }
    }
    
    func removeAccount(account: Account<TOTP>) {
        do {
            try account.remove(from: keychain)
            guard let index = accounts.firstIndex(of: account) else { return }
            accounts.remove(at: index)
        } catch let error {
            self.error = error
        }
    }
    
    func reloadAccounts() {
        do {
            accounts = try accountProvider()
        } catch let error {
            self.error = error
        }
    }
    
    func filterAccounts(with url: URL) {
        do {
            accounts = try accountProvider().filter {
                if let issuer = $0.issuer?.lowercased() {
                    return url.absoluteString.lowercased().contains(issuer)
                }
                return false
            }
        } catch let error {
            self.error = error
        }
    }
    
    func accounts(for url: URL) throws -> [Account<TOTP>] {
        return try accountProvider().filter {
            if let issuer = $0.issuer?.lowercased() {
                return url.absoluteString.lowercased().contains(issuer)
            }
            return false
        }
    }
    
    func resetError() {
        error = nil
    }
    
    static func loadAccountsFromKeychain() throws -> [Account<TOTP>] {
        return try Account<TOTP>.loadAll(from: keychain)
    }
    
}
