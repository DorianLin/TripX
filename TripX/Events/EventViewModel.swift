//
//  EventViewModel.swift
//  TripX
//
//  Created by JL on 2022/4/4.
//

import Foundation
import SwiftUI
import SQLite

class EventViewModel: ObservableObject {
    
    var trip: Trip = Trip(id: "", name: "", start: Date.now, end: Date.now, location: "", imageURL: "")
    
    @Published var events: [Event] = []

    @Published var routeGroupByDate: [String: [Event]] = [:]
    @Published var routeDate: String = ""
    @Published var routeEvents: [Event] = []

    //MARK: - Previous Route
    func preparePreviousRoute() {
        
        print("Previous Date")
        let dates = routeGroupByDate.keys.sorted(by: >)
        guard dates.count > 1 else {
            return
        }
        
        guard let currentIndex = dates.firstIndex(of: routeDate) else {
            return
        }

        //already first
        if currentIndex == 0 {
            return
        }
        
        routeDate = dates[currentIndex - 1]
        routeEvents = routeGroupByDate[routeDate] ?? []
        
        print(routeEvents)
    }
    
    //MARK: - Next Route
    func prepareNextRoute() {
        
        print("Next Date")

        let dates = routeGroupByDate.keys.sorted(by: >)
        guard dates.count > 1 else {
            return
        }
        
        guard let currentIndex = dates.firstIndex(of: routeDate) else {
            return
        }

        //already last
        guard currentIndex + 1 < dates.count else {
            return
        }
        
        routeDate = dates[currentIndex + 1]
        routeEvents = routeGroupByDate[routeDate] ?? []
        
        print(routeEvents)
    }
    
    //MARK: - Next Route
    func fetchEvents(for trip: Trip) {
        
        self.trip = trip
        
        guard !trip.id.isEmpty else {
            TripDatabase.shared.queryTrips { [unowned self] success, trips in
                if let trip = trips?.first {
                    self.fetchDefaultEvents(for: trip)
                }
            }
            return
        }
        
        TripDatabase.shared.queryEvents(for: trip) { success, events in
            if let events = events {
                self.events = events
                self.routeGroupByDate = Dictionary(grouping: events) { event in
                    return event.dateDescription()
                }
            }
        }
    }
    
    private func fetchDefaultEvents(for trip: Trip) {
        
        self.trip = trip
        
        TripDatabase.shared.queryEvents(for: trip) { success, events in
            if let events = events {
                self.events = events
                self.routeGroupByDate = Dictionary(grouping: events) { event in
                    return event.dateDescription()
                }
                self.routeDate = self.routeGroupByDate.keys.first ?? ""
                self.routeEvents = !self.routeDate.isEmpty ? self.routeGroupByDate[self.routeDate]! : []
            }
        }
    }
}

