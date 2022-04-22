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
            
            NavigationLink(destination: EventAddView(trip: trip, event: event), isActive: $navigateToModifyEvent) {
                
                VStack(alignment: .leading) {
                    Text(event.name)
                        .font(.title3)
                        .foregroundColor(event.completed ? .gray : AppThemeColor)
                    Text(DateFormatter.tripEventTimeFormatter.string(from: event.time))
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(event.location)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Divider().background(Color.blue)
                }
                .padding(.leading, 10)
                .padding(.vertical, 5)
                .onTapGesture {
                    navigateToModifyEvent.toggle()
                }
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
        let event = Event(tripId: "1", name: "The Art Institute of Chicago", date: Date().addingTimeInterval(86400), time: Date().addingTimeInterval(86400), location: "South Michigan Avenue, 芝加哥伊利諾伊州美國", latitude: 41.879800158879405, longitude: -87.62374548861116)
        EventItemView(trip: trip, event: event)
    }
}
