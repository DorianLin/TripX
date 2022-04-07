// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import GoogleMaps
import SwiftUI
import ToastViewSwift

/// The wrapper for `GMSMapView` so it can be used in SwiftUI
struct MapView: UIViewRepresentable {

    @EnvironmentObject private var viewmodel: EventViewModel

    var onAnimationEnded: () -> ()
    
    private let gmsMapView = GMSMapView(frame: .zero)
    private let defaultZoomLevel: Float = 16

    func makeUIView(context: Context) -> GMSMapView {
        
        let defaultLocation = CLLocationCoordinate2D(latitude: 41.935326889524795, longitude: -87.6314288347446) //default is chicago
        
        gmsMapView.camera = GMSCameraPosition.camera(withTarget: defaultLocation, zoom: defaultZoomLevel)
        gmsMapView.delegate = context.coordinator
        gmsMapView.isUserInteractionEnabled = true
        return gmsMapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        
        //clean all
        uiView.clear()
        
        var bounds = GMSCoordinateBounds()

        let markers: [GMSMarker] = viewmodel.routeEvents.map {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
          marker.title = $0.location
          return marker
        }
        markers.forEach { marker in
          marker.map = uiView
            bounds = bounds.includingCoordinate(marker.position)
        }
        
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        gmsMapView.animate(with: update)

//        if let firstEvent = viewmodel.routeEvents.first {
//            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: firstEvent.latitude, longitude: firstEvent.longitude))
//            marker.title = firstEvent.location
//            let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: defaultZoomLevel)
//            CATransaction.begin()
//            CATransaction.setValue(NSNumber(floatLiteral: 5), forKey: kCATransactionAnimationDuration)
//            gmsMapView.animate(with: GMSCameraUpdate.setCamera(camera))
//            CATransaction.commit()
//        }
        
        print("update mapview：updateUIView")
        displayTripEventsRoute(events: viewmodel.routeEvents)
    }

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    
    func createImage(_ text: String) -> UIImage {

        let color = UIColor.white
        // select needed color

        // the string to colorize
        let attrs: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: UIFont.boldSystemFont(ofSize: 12)]
        let attrStr = NSAttributedString(string: text, attributes: attrs)
        // add Font according to your need
        let image = UIImage(named: "marker_bubble")!
        // The image on which text has to be added
        
        let width = 120.0
        let height = 120.0
        UIGraphicsBeginImageContext(CGSize(width: 150, height: 150))
        image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height))
        let rect = CGRect(x: ceil(15/120.0*width), y: ceil(25/120.0*height), width: ceil(90/120.0*width), height: ceil(65/120.0*height))

        attrStr.draw(in: rect)

        let markerImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return markerImage
    }

  final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
      var mapView: MapView

      init(_ mapView: MapView) {
        self.mapView = mapView
      }

      func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
  //      let marker = GMSMarker(position: coordinate)
  //      self.mapView.polygonPath.append(marker)
      }

      func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.mapView.onAnimationEnded()
      }
      
      func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
          
          if overlay.isKind(of: GMSPolyline.self) && overlay.zIndex == 99 {
              print("Click plan route：\(overlay.title)")
          }
      }
  }
}
