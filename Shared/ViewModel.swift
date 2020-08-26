//
//  ViewModel.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 26.08.20.
//

import Foundation
import OTPKit

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
    
    init() {
        reloadAccounts()
    }
    
    init(accounts: [Account<TOTP>]) {
        self.accounts = accounts
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
        self.error = nil
        do {
            let keychainAccounts = try Account<TOTP>.loadAll(from: keychain)
            accounts = keychainAccounts
        } catch let error {
            self.error = error
        }
    }
    
    func resetError() {
        error = nil
    }
    
}
