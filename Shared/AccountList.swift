//
//  AccountList.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 24.08.20.
//

import SwiftUI
import OTPKit

struct AccountList: View {
    @Binding var accounts: [Account<TOTP>]

    var body: some View {
        if !accounts.isEmpty {
            List {
                ForEach(accounts) { account in
                    AccountView(account: account)
                        .contextMenu(
                            ContextMenu {
                                Button("Delete") {
                                    guard let index = accounts.firstIndex(of: account) else { return }
                                    try? account.remove(from: keychain)
                                    accounts.remove(at: index)
                                }
                            }
                        )
                }
                .onDelete { indexSet in
                    indexSet.forEach { try? accounts[$0].remove(from: keychain) }
                    accounts.remove(atOffsets: indexSet)
                }
            }
        } else {
            Text("No Accounts").font(.title)
        }
    }
}

struct AccountList_Previews: PreviewProvider {
    static var previews: some View {
        AccountList(accounts: .constant(sampleAccounts))
    }
}
