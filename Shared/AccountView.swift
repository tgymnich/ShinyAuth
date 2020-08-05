//
//  AccountView.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 30.6.20.
//

import SwiftUI
import OTPKit

struct AccountView: View {
    let account: Account<TOTP>
    @State private var currentCode: String = ""
    @State private var progress: CGFloat = 0.0
    @State private var showCopiedMessage = false

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
                if !showCopiedMessage {
                    GradientText(currentCode, colors: [.green, .blue], progress: progress)
                        .font(.title3)
                        .transition(.scale)
                        .onAppear {
                            currentCode = account.otpGenerator.code()
                        }
                        .onReceive(account.otpGenerator.publisher) { token in
                            currentCode = token.code
                            progress = -0.99
                            withAnimation(.linear(duration: token.timeRemaining)) {
                                progress = 0.99
                            }
                        }
                        .onTapGesture {
                            #if os(macOS)
                            NSPasteboard.general.setString(account.otpGenerator.code(), forType: .string)
                            #else
                            UIPasteboard.general.string = account.otpGenerator.code()
                            #endif

                            withAnimation {
                                showCopiedMessage = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showCopiedMessage = false
                                }
                            }
                        }
                } else {
                    GradientText("copied!", colors: [.yellow, .red, .orange], progress: 0).font(.title3)
                        .transition(.slide)
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
