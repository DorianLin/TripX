////
////  TripTabView.swift
////  TripX
////
////  Created by JL on 2022/4/7.
////
//
//import SwiftUI
//
//struct TripTabView: View {
//
//    var viewControllers: [UIHostingController<AnyView>]
//
//    @State var selectedIndex: Int = 0
//
//    init(_ views: [Tab]) {
//        self.viewControllers = views.map {
//            let host = UIHostingController(rootView: $0.view)
//            host.tabBarItem = $0.barItem
//            return host
//        }
//    }
//
//    var body: some View {
//        TripTabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
//            .edgesIgnoringSafeArea(.all)
//    }
//
//    struct Tab {
//        var view: AnyView
//        var barItem: UITabBarItem
//
//        init<V: View>(view: V, barItem: UITabBarItem) {
//            self.view = AnyView(view)
//            self.barItem = barItem
//        }
//
//        // convenience
//        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
//            let selectedImage = selectedImage != nil ? UIImage(systemName: selectedImage!) : nil
//            let barItem = UITabBarItem(title: title, image: UIImage(systemName: image), selectedImage: selectedImage)
//            self.init(view: view, barItem: barItem)
//        }
//    }
//}
//
//struct TripTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        TripTabView([TripTabView.Tab(view: Text("First tab"), title: "First Tab", image: "paperplane.fill", selectedImage: nil)])
//    }
//}
