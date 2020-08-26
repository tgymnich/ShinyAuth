//
//  ContentView.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var showNewAccount = false
    
    var body: some View {
        NavigationViewWrapper {
            AccountList(viewModel: viewModel)
            .navigationTitle("Shiny")
            .sheet(isPresented: $showNewAccount) {
                withAnimation {
                    viewModel.reloadAccounts()
                }
                showNewAccount = false
            } content: {
                #if os(iOS)
                ScannerView(showScanner: $showNewAccount).edgesIgnoringSafeArea(.bottom)
                #else
                NewAccountView(showNewAccount: $showNewAccount) { account in
                    withAnimation {
                        viewModel.addAccount(account)
                    }
                }
                #endif
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        showNewAccount = true
                    } label: {
                        #if os(iOS)
                        Image(systemName: "qrcode")
                        #else
                        Image(systemName: "plus")
                        #endif
                    }
                }
            }
            .onOpenURL { url in
                viewModel.addAccount(url: url)
            }
            .onAppear {
                viewModel.reloadAccounts()
            }
                .emittingError(viewModel.error, errorHandler: viewModel.resetError)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel(accounts: sampleAccounts))
    }
}
