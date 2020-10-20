//
//  ContentView.swift
//  Shared
//
//  Created by Tim Gymnich on 28.6.20.
//

import SwiftUI
import OTPKit

enum SheetKind: String, Identifiable {
    var id: String { rawValue }
    case scan
    case add
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State private var showNewAccount = false
    @State private var activeSheet: SheetKind? = nil
    var body: some View {
        NavigationViewWrapper {
            #if os(iOS) || os(macOS)
            AccountList(viewModel: viewModel)
            .navigationTitle("Shiny")
            .sheet(item: $activeSheet) {
                withAnimation {
                    viewModel.reloadAccounts()
                }
                activeSheet = nil
            } content: { sheet in
                switch sheet {
                case .scan:
                    #if os(iOS)
                    ScannerView(activeSheet: $activeSheet).edgesIgnoringSafeArea(.bottom)
                    #endif
                case .add:
                    NewAccountView(activeSheet: $activeSheet) { account in
                        withAnimation {
                            viewModel.addAccount(account)
                        }
                    }
                }
            }
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                    Button {
                        activeSheet = .scan
                    } label: {
                        Image(systemName: "qrcode")
                    }
                }
                #elseif os(macOS)
                ToolbarItem {
                    Button {
                        activeSheet = .add
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                #endif
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
