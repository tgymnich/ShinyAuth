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
            List {
                ForEach(viewModel.accounts) { account in
                    AccountView(account: account)
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
