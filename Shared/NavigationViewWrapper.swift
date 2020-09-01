//
//  NavigationViewWrapper.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 25.08.20.
//

import SwiftUI

struct NavigationViewWrapper<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        #if os(macOS)
        content()
        #else
        NavigationView {
            content()
        }.navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

struct NavigationViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
        NavigationViewWrapper { Text("Hello World") }
    }
}
