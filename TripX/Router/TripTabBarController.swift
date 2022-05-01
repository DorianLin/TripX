////
////  TripTabBarController.swift
////  TripX
////
////  Created by JL on 2022/4/7.
////
//
//import SwiftUI
//import UIKit
//
//struct TripTabBarController: UIViewControllerRepresentable {
//    var controllers: [UIViewController]
//    @Binding var selectedIndex: Int
//
//    func makeUIViewController(context: Context) -> UITabBarController {
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = controllers
//        tabBarController.delegate = context.coordinator
//        tabBarController.selectedIndex = 0
//        return tabBarController
//    }
//
//    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
//        tabBarController.selectedIndex = selectedIndex
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITabBarControllerDelegate {
//        var parent: TripTabBarController
//
//        init(_ tabBarController: TripTabBarController) {
//            self.parent = tabBarController
//        }
//
//        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//            parent.selectedIndex = tabBarController.selectedIndex
//        }
//    }
//}
