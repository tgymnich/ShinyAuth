//
//  SafariExtensionViewController.swift
//  Safari
//
//  Created by Tim Gymnich on 10.7.20.
//

import SafariServices
import SwiftUI


final class SafariExtensionViewController: SFSafariExtensionViewController {
    let viewModel = ViewModel()
    private lazy var contentView = ContentView(viewModel: viewModel)
    private lazy var swiftUI = NSHostingView(rootView: contentView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: 260, height: 120)
        self.view = swiftUI
    }
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        return shared
    }()

}
