//
//  ContentView.swift
//  Safari
//
//  Created by Tim Gymnich on 28.08.20.
//

import SwiftUI
import OTPKit

struct ContentView: View {
    @State var accounts: [Account<TOTP>] = sampleAccounts
    
    var body: some View {
        List {
            ForEach(accounts) { account in
                LiteAccountView(account: account)
            }
        }
        .background(Color.white)
    }
}
