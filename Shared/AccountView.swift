//
//  AccountView.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 30.6.20.
//

import SwiftUI
import OTPKit

struct AccountView: View {
    let account: Account
    @State private var currentCode: String = ""
    @State private var progress: CGFloat = 0.0

    var body: some View {
        HStack {
            Image(systemName: "photo")
            VStack(alignment: .leading) {
                if let issuer = account.issuer {
                    Text(issuer)
                        .font(.title3)
                    Text(account.label)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    Text(account.label)
                        .font(.title3)
                }
            }
            Spacer()
            VStack {
                GradientText(currentCode, colors: [.green, .blue], progress: progress)
                    .font(.title3)
                    .onAppear {
                        currentCode = account.otpGenerator.code()
                    }
                    .onReceive(TOTP.TOTPPublisher(totp: account.otpGenerator as! TOTP)) { token in
                        currentCode = token.code
                        progress = -0.99
                        withAnimation(.linear(duration: token.timeRemaining)) {
                            progress = 0.99
                        }
                    }
            }
        }.padding(.vertical, 10)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: sampleAccounts[0])
    }
}
