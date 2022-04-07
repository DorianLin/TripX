//
//  EventItemView.swift
//  TripX
//
//  Created by JL on 2022/4/5.
//

import SwiftUI

struct EventItemView: View {
    
    let trip: Trip

    @State var event: Event
    @State private var navigateToModifyEvent = false

    var body: some View {
        HStack {
            Button(action: {
                event.completed.toggle()
                updateEvent()
            }) {
                Image(systemName: event.completed ? "checkmark.circle" : "circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }

        }
        .padding(.horizontal, 20)
        .onAppear {
            print("event == \(event.name)")
            print("event time ==\(event.time)")
        }
    }
    
    private func updateEvent() {
        TripDatabase.shared.update(event: event) { _ in }
    }
}

struct EventItemView_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip(name: "Chicago", start: Date.now.addingTimeInterval(86400), end: Date.now.addingTimeInterval(3*86400), location: "Chicago", imageURL: "")
        EventItemView(trip: trip, event: event)
    }
}
