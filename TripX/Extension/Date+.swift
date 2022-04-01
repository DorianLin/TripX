//
//  Date+.swift
//  TripX
//
//  Created by JL on 2022/3/23.
//

import Foundation

extension Date {
   static func days(between fromDate: Date, toDate: Date) -> Int {
        let fromDate = Calendar.current.startOfDay(for: fromDate)
        let toDate = Calendar.current.startOfDay(for: toDate)
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate)
        return numberOfDays.day! + 1
    }
    
    func dateByAddDays(_days: Int) -> Date {
        return self.addingTimeInterval(24*3600)
    }
    
    func dateByMinusDays(_days: Int) -> Date {
        return self.addingTimeInterval(-24*3600)
    }
}

extension DateFormatter {
    static let tripDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MM/dd/yyyy"
        return formatter
    }()
    
    static let tripEventTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
