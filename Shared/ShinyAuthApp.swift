//
//  ShinyAuthApp.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit
import KeychainAccess

let keychain = Keychain(service: "ch.gymni.shiny-auth")
    .synchronizable(true)
    .accessibility(.afterFirstUnlock)

@main
struct ShinyAuthApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity, minHeight: 200, idealHeight: 500, maxHeight: .infinity, alignment: .center)
        }
    }
}

struct ShinyAuthApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
