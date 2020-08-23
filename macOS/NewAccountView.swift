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
                Text("URL").font(.caption).padding(.leading, 8)
                TextField("URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            if let account = account {
                AccountDetail(account: .constant(account)).animation(.easeIn)
            } else {
                AccountDetail.placeholder
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
                    Text("OK")
                }).disabled(account == nil)
            }
        }
        .padding()
        .frame(width: 350, height: 250, alignment: .center)
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
