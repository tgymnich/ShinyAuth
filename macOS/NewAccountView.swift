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
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("URL").fontWeight(.bold)
            TextField("URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
                })
            }
        }
        .padding()
        .frame(width: 300, height: 200, alignment: .center)
    }
    
    private func save() {
        guard let url = URL(string: urlString) else { return }
        let account = Account<TOTP>(from: url)
        try! account?.save(to: keychain)
    }
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        NewAccountView(showNewAccount: .constant(true))
    }
}
