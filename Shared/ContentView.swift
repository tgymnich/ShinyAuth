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
            #if os(iOS) || os(macOS)
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
                #elseif os(macOS)
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
                        #elseif os(macOS)
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
            #elseif os(watchOS)
            AccountList(viewModel: viewModel)
            #endif
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel(accounts: sampleAccounts))
    }
}
