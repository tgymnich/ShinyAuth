//
//  ShinyAuthApp.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit

@main
struct ShinyAuthApp: App {
    
    @State var accounts: [Account<TOTP>] = []
    
    var body: some Scene {
        WindowGroup {
            ContentView(accounts: $accounts).onOpenURL { url in
                guard let account = Account<TOTP>(from: url) else { return }
                try! account.save(to: keychain)
                accounts.append(account)
            }.frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity, minHeight: 200, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct ShinyAuthApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
