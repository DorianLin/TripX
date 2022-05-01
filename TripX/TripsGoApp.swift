//
//  TripXApp.swift
//  TripX
//
//  Created by JL on 2022/3/20.
//


import SwiftUI
import GoogleMaps

@main
struct TripXApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            TabbarContainerView()
                .environmentObject(viewRouter)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        GMSServices.provideAPIKey(googleMapKey)

        return true
    }
}
