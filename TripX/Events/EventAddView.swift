//
//  EventAddView.swift
//  TripX
//
//  Created by JL on 2022/4/4.
//

import SwiftUI
import AlertToast

struct EventAddView: View {
    
    let trip: Trip
    
    @State var event: Event = Event(tripId: "", name: "", date: Date.now, time: Date.now, location: "", latitude: 0, longitude: 0)

    @Environment(\.presentationMode) var presentationMode

    @State private var searchLocation = false

    @State private var nameWrong = false
    @State private var endeventTimeWrong = false
    @State private var locationWrong = false
    @State private var showAddEventSuccess: Bool = false

    var body: some View {
        List {
            Section {
                HStack {
                    Image(systemName: "pencil.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.orange)
                        .clipped()
                        .padding(.horizontal, 5)

                    TextField("Event Description", text: $event.name)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .modifier(Shake(shakes: nameWrong ? 2 : 0))
                        .animation(Animation.linear, value: nameWrong)
                        .padding(.horizontal, 5)
                }
                .padding(.vertical, 10)
            }
            
            Section {
                HStack {
                    Image(systemName: "calendar.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColorPink)
                        .clipped()
                        .padding(.horizontal, 5)

                    DatePicker("Date", selection: $event.date, in: trip.start...trip.end, displayedComponents: [.date])
                        .padding(.horizontal, 5)
                }
                .padding(.vertical, 10)
            }
            
            Section {
                HStack {
                    Image(systemName: "clock.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColorBlue)
                        .clipped()
                        .padding(.horizontal, 5)

                    DatePicker("Time", selection: $event.time, displayedComponents: [.hourAndMinute])
                        .modifier(Shake(shakes: endeventTimeWrong ? 2 : 0))
                        .animation(Animation.linear, value: endeventTimeWrong)
                        .padding(.horizontal, 5)
                }
                .padding(.vertical, 10)
            }

            Section {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColorBlue)
                        .clipped()
                        .padding(.horizontal, 5)

                    Text("Location").padding(.horizontal, 5)
                    Text(event.location).foregroundColor(.gray).font(.footnote).lineLimit(2)
                    Spacer()
                    Button(action: {
                        searchLocation.toggle()
                    }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .modifier(Shake(shakes: locationWrong ? 2 : 0))
                .animation(Animation.linear, value: locationWrong)
                .padding(.vertical, 10)
            }
            
            Section {
                HStack {
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColorBlue)
                        .clipped()
                        .padding(.horizontal, 5)

                    Button(
                        "Navigate to location",
                    action: {
                        let lat = event.latitude
                        let lon = event.longitude
                        if (lat != 0 && lon != 0) {
                            let url = URL(string: "maps://?saddr=&daddr=\(lat),\(lon)")
                            if UIApplication.shared.canOpenURL(url!) {
                                  UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }
                        }
                        
                    })
                }
            }
            .padding(.vertical, 10)
        }
        .navigationTitle(event.tripId.isEmpty ? "Add an Event": "Modify the Event")
        .toolbar {
            Button("Save") {
                
                if event.tripId.isEmpty {
                    saveNewEvent()
                } else {
                    modifyEvent()
                }
            }
        }
        .sheet(isPresented: $searchLocation, onDismiss: {searchLocation = false}) {
            EventAddressSearchView(event: $event)
        }
        .toast(isPresenting: $showAddEventSuccess, duration: 1, tapToDismiss: false, offsetY: 0.0) {
            
            AlertToast(displayMode: .hud, type: .complete(Color.green), title: "Add Event success", subTitle: nil, style: .none)
        }
    }
    
    //MARK: - Save Event
    private func saveNewEvent() {
        
        event.tripId = trip.id
        if event.date.timeIntervalSince1970 < trip.start.timeIntervalSince1970 {
            event.date = trip.start
        }
        
        guard !event.name.isEmpty else {
            withAnimation {
                nameWrong.toggle()
            }
            return
        }
        
        guard !event.latitude.isZero && !event.longitude.isZero else {
            withAnimation {
                locationWrong.toggle()
            }
            return
        }
                
        TripDatabase.shared.add(event: event) { success in
            if success {
                print("add event into database success")
                self.showAddEventSuccess.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentationMode.wrappedValue.dismiss()                }
            } else {
                print("add event into database failed")
            }
        }
    }
    
    //MARK: - Modify Event
    private func modifyEvent() {
        
        guard !event.name.isEmpty else {
            withAnimation {
                nameWrong.toggle()
            }
            return
        }
        
        guard !event.latitude.isZero && !event.longitude.isZero else {
            withAnimation {
                locationWrong.toggle()
            }
            return
        }
        print("before: \(event.longitude) + \(event.latitude)")
                
        TripDatabase.shared.update(event: event) { success in
            if success {
                print("add event into database success")
                self.showAddEventSuccess.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    presentationMode.wrappedValue.dismiss()                }
            } else {
                print("add event into database failed")
            }
        }
        print("after: \(event.longitude) + \(event.latitude)")
    }
}

struct EventAddView_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip(name: "Chicago", start: Date.now.addingTimeInterval(86400), end: Date.now.addingTimeInterval(3*86400), location: "Chicago", imageURL: "")
        EventAddView(trip: trip)
    }
}
