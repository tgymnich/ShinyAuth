//
//  NewAccountView.swift
//  macOS
//
//  Created by Tim Gymnich on 19.08.20.
//

import SwiftUI
import OTPKit
import KingfisherSwiftUI

struct NewAccountView: View {
    @Binding var activeSheet: SheetKind?
    @State private var urlString = ""
    private var accountURL: URL? { URL(string: urlString)?.standardized }
    private var account: Account<TOTP>? {
        guard let url = accountURL else { return nil }
        return try? Account(from: url)
    }
    var onDismiss: ((Account<TOTP>) -> Void)?

    var body: some View {
        NavigationViewWrapper {
            Form {
                Section(header: Text("URL")) {
                    TextField("URL", text: $urlString)
                }
                Section {
                    if let account = account {
                        AccountDetail(account: .constant(account)).animation(.easeIn)
                    } else {
                        AccountDetail.placeholder
                    }
                }
            }
            .navigationTitle("Add New Account")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        activeSheet = nil
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if let account = account {
                            onDismiss?(account)
                        }
                        activeSheet = nil
                    }) {
                        Text("Save")
                    }.disabled(account == nil)
                }
            }
        }
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(activeSheet: .constant(SheetKind.add))
    }
}

