//
//  TabbarContainerView.swift
//  TripX
//
//  Created by JL on 2022/4/7.
//

import SwiftUI

enum AppTab {
    case trip, map, account
}

class ViewRouter: ObservableObject {
    @Published var current: AppTab = .trip
}

struct TabbarContainerView: View {
        
    @StateObject private var eventViewModel = EventViewModel()

    @EnvironmentObject private var viewRouter: ViewRouter
    
    var body: some View {
//        TripTabView([
//                    TripTabView.Tab(view: TripHomeView(viewmodel: TripViewModel()), title: "Trips", image: "paperplane.fill"),
//                    TripTabView.Tab(view: MapHomeView(), title: "Map", image: "map.fill"),
//                    TripTabView.Tab(view: MapHomeView().navigationBarHidden(true), title: "Account", image: "person.crop.circle")
//        ])
//            .accentColor(AppThemeColor)
//            .environmentObject(eventViewModel)
        

        TabView(selection: $viewRouter.current) {
            TripHomeView(viewmodel: TripViewModel()).tabItem {
                Image(systemName: "paperplane.fill")
                Text("Trips")
            }
            .tag(AppTab.trip)

//            MapHomeView().tabItem {
//                Image(systemName: "map.fill")
//                Text("Map")
//            }
//            .tag(AppTab.map)

            AccountView().tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }
            .tag(AppTab.account)
        }
        .accentColor(AppThemeColor)
        .environmentObject(eventViewModel)
    }
}

struct TabbarContainerView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarContainerView()
    }
}
