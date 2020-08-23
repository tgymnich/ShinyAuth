//
//  NewAccountView.swift
//  macOS
//
//  Created by Tim Gymnich on 19.08.20.
//

import SwiftUI
import OTPKit

struct NewAccountView: View {
    @Binding var showNewAccount: Bool
    @State private var urlString = ""
    private var accountURL: URL? { URL(string: urlString)?.standardized }
    private var account: Account<TOTP>? {
        guard let url = accountURL else { return nil }
        return Account(from: url)
    }
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Add a new Account").font(.title2)
            Spacer()
            VStack(alignment: .leading, spacing: 4) {
                Text("URL").font(.caption)
                TextField("URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: { showNewAccount = false }, label: {
                    Text("Cancel")
                })
                Button(action: {
                    save()
                    onDismiss?()
                    showNewAccount = false
                }, label: {
                    // TODO: enable button only when url is valid
                    Text("OK")
                }).disabled(account == nil)
            }
        }
        .padding()
        .frame(width: 300, height: 200, alignment: .center)
    }
    
    private func save() {
        try! account?.save(to: keychain)
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(showNewAccount: .constant(true))
    }
}
