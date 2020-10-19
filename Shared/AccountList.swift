//
//  AccountList.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 24.08.20.
//

import SwiftUI
import OTPKit

struct AccountList: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        if !viewModel.accounts.isEmpty {
            List {
                #if os(iOS) || os(macOS)
                ForEach(viewModel.accounts) { account in
                    AccountView(account: account)
                        .contextMenu(
                            ContextMenu {
                                Button("Delete") {
                                    viewModel.removeAccount(account: account)
                                }
                            }
                        )
                }
                .onDelete { indexSet in
                    let accounts = indexSet.map { viewModel.accounts[$0] }
                    accounts.forEach(viewModel.removeAccount(account:))
                }
                #elseif os(watchOS)
                ForEach(viewModel.accounts) { account in
                    WatchAccountView(account: account)
                }
                #endif
            }
        } else {
            Text("No Accounts").font(.title)
        }
    }
}

struct AccountList_Previews: PreviewProvider {
    static var previews: some View {
        AccountList(viewModel: ViewModel(accounts: sampleAccounts))
    }
}
