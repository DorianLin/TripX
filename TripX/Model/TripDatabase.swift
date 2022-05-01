//
//  TripDatabase.swift
//  TripX
//
//  Created by JL on 2022/3/21.
//

import UIKit
import SQLite

// https://morioh.com/p/cb7e610d078c

class TripDatabase: NSObject {

    static let shared = TripDatabase()
            
    
    private var db: Connection!

    private let tripsTable = Table("trips")
    private let eventsTable = Table("events")

    private let id = Expression<String>("id")
    private let tripId = Expression<String>("tripId")
    private let name = Expression<String>("name")
    private let start = Expression<String>("start")
    private let end = Expression<String>("end")
    private let date = Expression<String>("date")
    private let time = Expression<String>("time")
    private let imageURL = Expression<String>("imageURL")
    private let location = Expression<String>("location")
    private let latitude = Expression<String>("latitude")
    private let longitude = Expression<String>("longitude")
    private let completed = Expression<Bool>("completed")

    
    override init() {
        
        super.init()
        
        sharedInit()
    }
    
    private func sharedInit() {
       
        //open db
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            print("Print directory： \(documentDirectory.path)")
            let fileUrl = documentDirectory.appendingPathComponent("TripX").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.db = database
            
        } catch {
            print(error)
        }
        
        let createTripsTable = self.tripsTable.create(temporary: false, ifNotExists: true, withoutRowid: false) { (tableBuilder) in
            tableBuilder.column(self.id)
            tableBuilder.column(self.name)
            tableBuilder.column(self.start)
            tableBuilder.column(self.end)
            tableBuilder.column(self.imageURL)
            tableBuilder.column(self.location)
        }
        
        let createEventsTable = self.eventsTable.create(temporary: false, ifNotExists: true, withoutRowid: false) { (tableBuilder) in
            tableBuilder.column(self.id)
            tableBuilder.column(self.tripId)
            tableBuilder.column(self.name)
            tableBuilder.column(self.date)
            tableBuilder.column(self.time)
            tableBuilder.column(self.location)
            tableBuilder.column(self.latitude)
            tableBuilder.column(self.longitude)
            tableBuilder.column(self.completed)
        }
        
        do {
            try self.db.run(createTripsTable)
            try self.db.run(createEventsTable)
        } catch {
            print(error)
        }
    }

    // MARK: - Trips DB - Add Trip
    // https://imyuewu.github.io/2019/05/02/Swift基础-Result介绍/
    
    func add(trip: Trip, result: @escaping (_ success: Bool) -> Void) {
        
        let insert = self.tripsTable.insert(self.id <- trip.id,
                                            self.name <- trip.name,
                                            self.start <- "\(Int(trip.start.timeIntervalSince1970))",
                                            self.end <- "\(Int(trip.end.timeIntervalSince1970))",
                                            self.imageURL <- trip.imageURL,
                                            self.location <- trip.location)

        do {
            try self.db.run(insert)
            DispatchQueue.main.async {
                result(true)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Trips DB - Delete Trip

    func delete(trip: Trip, result: @escaping (_ success: Bool) -> Void) {
        
        let query = self.tripsTable.filter(tripsTable[id] == trip.id)

        do {
            try self.db.run(query.delete())
            DispatchQueue.main.async {
                result(true)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Trips DB - Query Trips

    func queryTrips(result: @escaping (_ success: Bool, _ trips: [Trip]?) -> Void) {

        do {
            let query = try self.db.prepare(self.tripsTable.order(start))
            
            var all = [Trip]()
            
            for item in query {
                
                let trip = Trip(id: item[id], name: item[name], start: Date.init(timeIntervalSince1970: Double(item[start]) ?? 0), end: Date.init(timeIntervalSince1970: Double(item[end]) ?? 0), location: item[location], imageURL: item[imageURL])

                all.append(trip)
            }
            
            result(true, all)
            
        } catch {
            print(error)
            result(false, nil)
        }
    }
    
    // MARK: - Event DB - Add Event
    
    func add(event: Event, result: @escaping (_ success: Bool) -> Void) {
        
        let insert = self.eventsTable.insert(self.id <- event.id,
                                             self.tripId <- event.tripId,
                                             self.name <- event.name,
                                             self.date <- "\(Int(event.date.timeIntervalSince1970))",
                                             self.time <- "\(Int(event.time.timeIntervalSince1970))",
                                            self.location <- event.location,
                                             self.latitude <- "\(Double(event.latitude))",
                                             self.longitude <- "\(Double(event.longitude))", self.completed <- event.completed)

        do {
            try self.db.run(insert)
            DispatchQueue.main.async {
                result(true)
            }
        } catch {
            print(error)
        }
    }
    
    // MARK: - Event DB - Add Event
    
    func update(event: Event, result: @escaping (_ success: Bool) -> Void) {
        
        let item = self.eventsTable.filter(self.id == event.id)
        let updateItem = item.update(self.name <- event.name,
                                     self.date <- "\(Int(event.date.timeIntervalSince1970))",
                                     self.time <- "\(Int(event.time.timeIntervalSince1970))",
                                    self.location <- event.location,
                                     self.latitude <- "\(Int(event.latitude))",
                                     self.longitude <- "\(Int(event.longitude))", self.completed <- event.completed)
        
        do {
            try self.db.run(updateItem)
            DispatchQueue.main.async {
                result(true)
            }
        } catch {
            print(error)
        }
    }
    
    func delete(event: Event, result: @escaping (_ success: Bool) -> Void) {
        
        let query = self.eventsTable.filter(eventsTable[id] == event.id)

        do {
            try self.db.run(query.delete())
            DispatchQueue.main.async {
                result(true)
            }
        } catch {
            print(error)
        }
    }
    
    func queryEvents(for trip: Trip, result: @escaping (_ success: Bool, _ events: [Event]?) -> Void) {

        do {
            let query = try self.db.prepare(self.eventsTable.filter(eventsTable[tripId] == trip.id).order(start))

            var all = [Event]()
            
            for item in query {
                let event = Event(id: item[id], tripId: item[tripId], name: item[name], date: Date.init(timeIntervalSince1970: Double(item[date]) ?? 0), time: Date.init(timeIntervalSince1970: Double(item[time]) ?? 0), location: item[location], latitude: Double(item[latitude]) ?? 0, longitude: Double(item[longitude]) ?? 0, completed: item[completed])
                all.append(event)
            }
            
            result(true, all)
            
        } catch {
            print(error)
            result(false, nil)
        }
    }
}
