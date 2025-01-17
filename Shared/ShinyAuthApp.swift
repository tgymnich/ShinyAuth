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
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS) || os(macOS)
            ContentView()
                .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity, minHeight: 200, idealHeight: 500, maxHeight: .infinity, alignment: .center)
            #elseif os(watchOS)
            ContentView()
            #endif
        }
        #if os(macOS)
        Settings {
            SettingsView()
                .padding(20)
                .frame(width: 350, height: 200)
        }
        #endif
    }
}

struct ShinyAuthApp_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello, World!")
    }
}
