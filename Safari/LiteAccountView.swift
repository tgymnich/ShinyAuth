//
//  LiteAccountView.swift
//  Safari
//
//  Created by Tim Gymnich on 28.08.20.
//

import SwiftUI
import OTPKit

struct LiteAccountView: View {
    let account: Account<TOTP>
    @State private var currentCode: String = ""
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                if let issuer = account.issuer {
                    Text(issuer)
                        .font(.body)
                    Text(account.label)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                } else {
                    Text(account.label)
                        .font(.body)
                }
            }
            Spacer()
            VStack {
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

        }.padding(.vertical, 10)
    }
}
