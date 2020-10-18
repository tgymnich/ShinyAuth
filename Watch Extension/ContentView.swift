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
        VStack {
            Text("Accounts (\(viewModel.accounts.count))")
            List {
                ForEach(viewModel.accounts) { account in
                    VStack {
                        Text(account.label)
                        Text(account.issuer ?? "n/a")
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
