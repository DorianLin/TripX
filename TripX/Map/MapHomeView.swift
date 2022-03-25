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
        }
    }
    

}

struct MapHomeView_Previews: PreviewProvider {
    static var previews: some View {
        MapHomeView()
    }
}
