//
//  TripViewModel.swift
//  TripX
//
//  Created by JL on 2022/4/2.
//

import Foundation
import SwiftUI
import SQLite

class TripViewModel: ObservableObject {
    
    @Published var trips: [Trip] = []
    
    init() {
      fetchTrips()
    }

    func fetchTrips() {
        TripDatabase.shared.queryTrips { suc, trips in
            if let trips = trips {
                self.trips = trips
            }
        }
    }
    
    func add(_ trip: Trip, result: @escaping (_ success: Bool) -> Void) {
        trips.append(trip)
        TripDatabase.shared.add(trip: trip, result: result)
    }
}
