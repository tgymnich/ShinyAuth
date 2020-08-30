//
//  SafariExtensionHandler.swift
//  Safari
//
//  Created by Tim Gymnich on 10.7.20.
//

import SafariServices

final class SafariExtensionHandler: SFSafariExtensionHandler {
        
    override func popoverWillShow(in window: SFSafariWindow) {
        window.getActiveTab { tab in
            tab?.getActivePage { page in
                page?.getPropertiesWithCompletionHandler { properties in
                    guard let url = properties?.url else { return }
                    NotificationCenter.default.post(name: .didNavigate, object: self, userInfo: ["url": url])
                }
            }
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        window.getToolbarItem { item in
            window.getActiveTab { tab in
                tab?.getActivePage { page in
                    page?.getPropertiesWithCompletionHandler { properties in
                        guard let url = properties?.url else {
                            item?.setEnabled(false)
                            return validationHandler(true,"")
                        }
                        let accounts = try? SafariExtensionViewController.shared.viewModel.accounts(for: url)
                        item?.setEnabled(!(accounts?.isEmpty ?? true))
                        if let token = accounts?.first?.otpGenerator.code() {
                            page?.dispatchMessageToScript(withName: "credentials", userInfo: ["token": token])
                        }
                        return validationHandler(true, "")
                    }
                }
            }
            item?.setEnabled(false)
        }
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
}
