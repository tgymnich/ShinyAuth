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
        #if os(iOS)
        navigationView
        #else
        navigationView
            .padding()
            .frame(width: 350, height: 250, alignment: .center)
        #endif
    }
    
    var navigationView: some View {
        NavigationViewWrapper {
            Form {
                #if os(macOS)
                Text("Add New Account").font(.title2)
                Spacer()
                #endif
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
                HStack {
                    Spacer()
                        Button("Cancel") {
                            activeSheet = nil
                        }
                        Button("OK") {
                            if let account = account {
                                onDismiss?(account)
                            }
                            activeSheet = nil
                        }.disabled(account == nil)
                    }
            }
            .navigationTitle("Add New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        activeSheet = nil
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
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

