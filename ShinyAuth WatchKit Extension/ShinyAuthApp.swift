//
//  ShinyAuthApp.swift
//  ShinyAuth WatchKit Extension
//
//  Created by Tim Gymnich on 18.10.20.
//

import SwiftUI

@main
struct ShinyAuthApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
