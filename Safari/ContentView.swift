//
//  ContentView.swift
//  Safari
//
//  Created by Tim Gymnich on 28.08.20.
//

import SwiftUI
import OTPKit

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.accounts) { account in
                AccountView(account: account)
            }
        }
        .padding()
        .background(Color.white.opacity(0.3))
        .onReceive(NotificationCenter.default.publisher(for: .didNavigate).receive(on: RunLoop.main)) {
            guard let url = $0.userInfo?["url"] as? URL else { return }
            viewModel.filterAccounts(with: url)
        }
    }
}

public extension Notification.Name {
    static let didNavigate = Notification.Name("didNavigate")
}
