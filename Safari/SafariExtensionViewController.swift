//
//  SafariExtensionViewController.swift
//  Safari
//
//  Created by Tim Gymnich on 10.7.20.
//

import SafariServices
import AppKit
import SwiftUI

final class SafariExtensionViewController: SFSafariExtensionViewController {
    
    let swiftUI = NSHostingView(rootView: ContentView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = swiftUI
    }
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width: 320, height: 240)
        return shared
    }()

}

struct SafariExtensionViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
