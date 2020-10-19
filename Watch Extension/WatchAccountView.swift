//
//  WatchAccountView.swift
//  Watch Extension
//
//  Created by Tim Gymnich on 19.10.20.
//

import SwiftUI
import OTPKit

struct WatchAccountView: View {
    let account: Account<TOTP>
    @State private var currentCode = ""
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            if let issuer = account.issuer {
                Text(issuer)
                    .font(.headline)
                Text(account.label)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                Text(account.label)
                    .font(.body)
            }
            GradientText(currentCode, colors: [.green, .blue], progress: progress, kerning: 1.0)
                .font(.title2)
                .transition(.scale)
                .onAppear {
                    currentCode = account.otpGenerator.code().group(groupSize: 3)
                }
                .onReceive(account.otpGenerator.publisher) { token in
                    currentCode = token.code.group(groupSize: 3)
                    progress = -0.99
                    withAnimation(.linear(duration: token.timeRemaining)) {
                        progress = 0.99
                    }
                }
        }
    }
}

struct WatchAccountView_Previews: PreviewProvider {
    static var previews: some View {
        WatchAccountView(account: sampleAccounts[0])
    }
}
