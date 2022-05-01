//
//  TripEventView.swift
//  TripX
//
//  Created by JL on 2022/3/22.
//

import SwiftUI

struct TripEventView: View {
    
    let trip: Trip
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var viewmodel: EventViewModel
    @EnvironmentObject private var viewRouter: ViewRouter

    @State private var presentRouteMap = false

    @State private var addNewEvent = false
    @State private var pushToMapDisplay: Bool = false
    
    var body: some View {
        ScrollView {
            if viewmodel.events.count > 0 {
                
                ForEach(viewmodel.routeGroupByDate.keys.sorted(by: >), id: \.self) { key in
                    Section(header:
                                HStack { 
                        Text(key).foregroundColor(.blue).font(.title3)
                        Spacer()
                        Image(systemName: "chevron.right.circle")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                            .foregroundColor(.blue)
                            .tint(.blue)
                        
                    }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                                .onTapGesture(perform: {
                        
                        showRoute(events: viewmodel.routeGroupByDate[key]!, in: key)
                    })
                    ) {
                        let events = viewmodel.routeGroupByDate[key]!.sorted(by: { $0.time.timeIntervalSince1970 < $1.time.timeIntervalSince1970 })
                        ForEach(events, id: \.id) { event in
                            EventItemView(trip: trip, event: event)
                        }
                    }
                }
            } else {
                Text("You don't have any plan in this trip yet. \n\nAdd one and start planning for your trip!")
                    .foregroundColor(AppThemeColor)
                    .padding(30)
                    .frame(height: 300)
            }
        }
        .onAppear(perform: {
            viewmodel.fetchEvents(for: self.trip)
        })
        .navigationTitle(trip.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: EventAddView(trip: trip), isActive: $addNewEvent) {
                    Button("Add an Event") {
                        addNewEvent.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $presentRouteMap, onDismiss: {presentRouteMap = false}) {
            MapHomeView().environmentObject(viewmodel)
        }
    }
    
    private func showRoute(events: [Event], in specialDay: String) {
        
        viewmodel.routeDate = specialDay
        viewmodel.routeEvents = events.filter({ !$0.completed })
        
//        viewRouter.current = .map
        print("Displaying routes")
        presentRouteMap.toggle()
    }
}

struct TripEventView_Previews: PreviewProvider {
    static var previews: some View {
        let trip = Trip(name: "Chicago", start: Date.now.addingTimeInterval(86400), end: Date.now.addingTimeInterval(3*86400), location: "Chicago", imageURL: "")
        TripEventView(trip: trip)
    }
}
