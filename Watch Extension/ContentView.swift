//
//  ContentView.swift
//  ShinyAuth Extension
//
//  Created by Tim Gymnich on 18.10.20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.accounts) { account in
                WatchAccountView(account: account)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
