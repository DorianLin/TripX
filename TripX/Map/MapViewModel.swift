////
////  TripViewModel.swift
////  TripX
////
////  Created by JL on 2022/4/1.
////
//
//import Foundation
//import SwiftUI
//
//
//class MapViewModel: ObservableObject {
//
//    @Published var trip: Trip
//
//    @Published var events: [Event] = []
//
//    init(trip: Trip) {
//        self.trip = trip
//        fetchTripEvents(trip)
//    }
//
//    func fetchTripEvents(_ trip: Trip) {
//        TripDatabase.shared.queryEvents(for: trip) { success, events in
//            if let events = events {
//                self.events = events
//            }
//        }
//    }
//}
