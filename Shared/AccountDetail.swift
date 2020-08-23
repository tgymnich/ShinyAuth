//
//  AccountDetail.swift
//  ShinyAuth
//
//  Created by Tim Gymnich on 24.08.20.
//

import SwiftUI
import KingfisherSwiftUI
import OTPKit

struct AccountDetail: View {
    static fileprivate let placeholderAccount = Account<TOTP>(label: "tg908@icloud.com", otp: TOTP(algorithm: .sha256, secret: "01234567890".data(using: .ascii)!, digits: 6, period: 3), issuer: "Cloudflare", imageURL: URL(string: "https://cdn.dribbble.com/users/103075/screenshots/622214/dribbble-simplified-cloud.png"))
    static let placeholder: some View = AccountDetail(account: .constant(placeholderAccount)).redacted(reason: .placeholder)
    
    @Binding var account: Account<TOTP>
    
    var body: some View {
            HStack {
                if let imageURL = account.imageURL {
                        KFImage(imageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 44)
                            .clipped()
                    } else {
                        IconView(text: String(account.issuer?.prefix(2) ?? account.label.prefix(2)))
                            .frame(width: 44, height: 44)
                    }
                Spacer()
                VStack(alignment: .leading) {
                        HStack {
                            Text("Label").font(.headline)
                            Spacer()
                            Text(account.label).font(.subheadline)
                        }
                        HStack {
                            Text("Issuer").font(.headline)
                            Spacer()
                            Text(account.issuer ?? "").font(.subheadline)
                        }
                        HStack {
                            Text("Algorithm").font(.headline)
                            Spacer()
                            Text(account.otpGenerator.algorithm.string).font(.subheadline)
                        }
                        HStack {
                            Text("Digits").font(.headline)
                            Spacer()
                            Text(account.otpGenerator.digits.description).font(.subheadline)
                        }
                        HStack {
                            Text("Period").font(.headline)
                            Spacer()
                            Text(account.otpGenerator.period.description).font(.subheadline)
                        }
                    }
                Spacer()
            }
    }
}

struct AccountDetail_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetail(account: .constant(AccountDetail.placeholderAccount))
    }
}
