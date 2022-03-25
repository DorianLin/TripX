//
//  TripHomeView.swift
//  TripX
//
//  Created by JL on 2022/3/18.
//

import SwiftUI

struct TripHomeView: View {
    init(viewmodel: TripViewModel) {
        self.viewmodel = viewmodel
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    @ObservedObject var viewmodel: TripViewModel

    @State private var addNewTrip = false
    @State private var pushToTripDetail: Bool = false
    
    @State private var selectedIndex = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Spacer().frame(height: 20)
                    
                    Picker("TripType", selection: $selectedIndex) {
                        Text("Upcomming").tag(0)
                        Text("Past").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer().frame(height: 20)
                    
                    let showTrips = selectedIndex == 0 ? viewmodel.trips.filter({$0.start.timeIntervalSince1970 >= Date().timeIntervalSince1970 }) :  viewmodel.trips.filter({$0.start.timeIntervalSince1970 < Date().timeIntervalSince1970 })
                    
                    if viewmodel.trips.count > 0 {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(showTrips, id: \.id) { trip in
                                NavigationLink(destination: TripEventView(trip: trip)) {
                                    HStack {
                                        Image(uiImage: UIImage.tripImage(trip.imageURL) ?? UIImage(systemName: "airplane.circle.fill")!)
                                            .resizable()
                                            .cornerRadius(6)
                                            .frame(width: 60, height: 60)
                                            .clipped()
                                        
                                        Spacer()
                                            .frame(width: 15)
                                        
                                        VStack(alignment: .leading) {
                                            Text(trip.name).font(.title2)
                                            Text(trip.start...trip.end) + Text(" (\(Date.days(between: trip.start, toDate: trip.end))days)")
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)
                    } else {
                        Text("No trips yet")
                            .foregroundColor(AppThemeColor)
                            .padding(30)
                            .frame(height: 300)
                    }
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                Button(action: {
                    addNewTrip.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $addNewTrip, onDismiss: {addNewTrip = false}) {
                TripAddView(viewmodel: viewmodel)
            }
        }
    }
}

struct TripHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TripHomeView(viewmodel: TripViewModel())
    }
}
