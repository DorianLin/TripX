//
//  EventAddressSearchView.swift
//  TripX
//
//  Created by JL on 2022/4/7.
//

import SwiftUI
import UIKit
import MapKit

struct EventAddressSearchView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MapKitSearchViewController

    @Environment(\.presentationMode) var presentationMode
    
    @Binding var event: Event

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MapKitSearchViewController {
        
        let mapKitSearch = MapKitSearchViewController(delegate: context.coordinator)
        mapKitSearch.completionEnabled = true
        mapKitSearch.geocodeEnabled = true
        mapKitSearch.userLocationRequest = .authorizedAlways
        return mapKitSearch
    }
    
    func updateUIViewController(_ uiViewController: MapKitSearchViewController, context: Context) {
        
    }
        
    class Coordinator: NSObject, MapKitSearchDelegate {
        
        func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, mapItem: MKMapItem) {
                
            parent.event.location = mapItem.name ?? ""
            parent.event.latitude = mapItem.placemark.location?.coordinate.latitude ?? 0.0
            parent.event.longitude = mapItem.placemark.location?.coordinate.longitude ?? 0.0
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, searchReturnedOneItem mapItem: MKMapItem) {
            
        }
        
        func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedListItem mapItem: MKMapItem) {
            
        }
        
        func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedGeocodeItem mapItem: MKMapItem) {
            
        }
        
        func mapKitSearch(_ mapKitSearchViewController: MapKitSearchViewController, userSelectedAnnotationFromMap mapItem: MKMapItem) {
            
        }
        
        let parent: EventAddressSearchView

        init(_ parent: EventAddressSearchView) {
            self.parent = parent
        }
    }
}
