//
//  SafariExtensionHandler.swift
//  Safari
//
//  Created by Tim Gymnich on 10.7.20.
//

import SafariServices

final class SafariExtensionHandler: SFSafariExtensionHandler {
        
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func popoverWillShow(in window: SFSafariWindow) {
        window.getActiveTab { tab in
            tab?.getActivePage { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let url = properties?.url else { return }
                    window.getToolbarItem { item in
                        let accounts = try? SafariExtensionViewController.shared.viewModel.accounts(for: url)
                        item?.setEnabled(!(accounts?.isEmpty ?? true))
                        NotificationCenter.default.post(name: .didNavigate, object: self, userInfo: ["url": url])
                    }
                }
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getActiveTab { tab in
            tab?.getActivePage { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let url = properties?.url else { return validationHandler(true,"") }
                    window.getToolbarItem { item in
                        let accounts = try? SafariExtensionViewController.shared.viewModel.accounts(for: url)
                        item?.setEnabled(!(accounts?.isEmpty ?? true))
                        validationHandler(true, "")
                    }
                }
            }
        }
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
