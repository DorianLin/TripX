//
//  MapHomeView.swift
//  TripX
//
//  Created by JL on 2022/3/20.
//

import SwiftUI
import GoogleMaps

struct MapHomeView: View {
    
    @EnvironmentObject private var viewmodel: EventViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .top) {
            MapView() {
                
            }
            if viewmodel.routeEvents.count > 0 {
                VStack {
                    HStack {
                        EmptyView()
                        Spacer()
                        Text(viewmodel.trip.name)
                            .font(.title2)
                        Spacer()
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30, weight: .bold))
                        }
                        .frame(width: 40, height: 40, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
//                        Button(action: {
//                            viewmodel.preparePreviousRoute()
//                        }) {
//                            Image(systemName: "chevron.left")
//                        }
                        
                        Text(viewmodel.routeDate)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                            )
                            .frame(height: 60)
                        
//                        Button(action: {
//                            viewmodel.prepareNextRoute()
//                        }) {
//                            Image(systemName: "chevron.right")
//                        }
                    }
                    .padding(.top, -10)
                }
                .padding(.top, 20)
                .zIndex(9999)
            }
        }
    }
    

}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
