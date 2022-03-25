//
//  TripModel.swift
//  TripX
//
//  Created by JL on 2022/3/21.
//

import Foundation

struct Trip: Equatable, Identifiable, Codable {
    private(set) var id = UUID().uuidString
    var name: String
    var start: Date
    var end: Date
    var location: String
    var imageURL: String
}

struct Event: Equatable, Identifiable, Codable {
    private(set) var id = UUID().uuidString
    var tripId: String
    var name: String
    var date: Date
    var time: Date
    var location: String
    var latitude: Double
    var longitude: Double
    var completed: Bool = false
    
    func dateDescription() -> String {
        return DateFormatter.tripDateFormatter.string(from: self.date)
    }
}
