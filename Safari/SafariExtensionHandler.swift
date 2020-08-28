//
//  SafariExtensionHandler.swift
//  Safari
//
//  Created by Tim Gymnich on 10.7.20.
//

import SafariServices
import OTPKit
import KeychainAccess

final class SafariExtensionHandler: SFSafariExtensionHandler {
    
    let viewModel = ViewModel()
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }

    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
//        NSLog("The extension's toolbar item was clicked")
//        window.getActiveTab { tab in
//            tab?.getActivePage { page in
//                page?.getPropertiesWithCompletionHandler { properties in
//                    window.getToolbarItem { item in
//                        item?.setBadgeText(properties?.url?.description ?? "???")
//                        guard let url = properties?.url else { return }
//                        let text = self.viewModel.accounts(for: url).first?.otpGenerator.code()
//                        item?.setBadgeText(text)
//                    }
//                }
//            }
//        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
//        window.getActiveTab { tab in
//            tab?.getActivePage { page in
//                page?.getPropertiesWithCompletionHandler { properties in
//                    guard let url = properties?.url else { return validationHandler(true, "") }
//                    window.getToolbarItem { item in
//                        let text = self.viewModel.accounts(for: url).first?.otpGenerator.code()
//                        item?.setBadgeText(text)
//                        validationHandler(true, "")
//                    }
//                }
//            }
//        }
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
