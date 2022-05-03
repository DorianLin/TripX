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

// https://developers.google.com/codelabs/maps-platform/maps-platform-ios-swiftui#6

import GoogleMaps
import SwiftUI
import ToastViewSwift

/// The wrapper for `GMSMapView` so it can be used in SwiftUI
struct MapView: UIViewRepresentable {

    @EnvironmentObject private var viewmodel: EventViewModel

    var onAnimationEnded: () -> ()
    
    // https://developers.google.com/maps/documentation/ios-sdk/reference/interface_g_m_s_map_view
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

        // https://developers.google.com/maps/documentation/ios-sdk/reference/interface_g_m_s_marker
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
        displayTripEventsRoute(events_unsort: viewmodel.routeEvents)
    }

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    func displayTripEventsRoute(events_unsort: [Event]) {
        let events = events_unsort.sorted(by: { $0.time.timeIntervalSince1970 < $1.time.timeIntervalSince1970 })

        guard events.count > 1 else {
            return
        }
        
        let originLocation = events.first!
        let destinationLocation = events.last!
        
        var waypoints = ""
        if events.count > 2 {//waypoints > 0
            for event in events[1..<events.count-1] {
                if waypoints.isEmpty {
                    waypoints = "&waypoints=\(event.latitude),\(event.longitude)"
                    continue
                }
                waypoints += "|\(event.latitude),\(event.longitude)"
            }
        }
        print("waypoints:  \(waypoints)")
        var urlPath = "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\(originLocation.latitude),\(originLocation.longitude)&destination=\(destinationLocation.latitude),\(destinationLocation.longitude)"
                    
        if !waypoints.isEmpty {
            urlPath += waypoints
        }
        urlPath += "&key=\(googleMapKey)"
        let newPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        print("********* \(urlPath)")
 
        guard let url = URL(string: newPath ?? "") else{
            print("Fail to generate URL")
                return
            }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) -> Void in

            do {
                if data != nil {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]

                    let status = dic["status"] as! String
                    var routesArray:String!
                    
                    //no search results
                    guard !status.elementsEqual("ZERO_RESULTS") else {
                        
                        DispatchQueue.main.async {
                            Toast.text("Find zero results for your trip route").show(haptic: .error)
                        }
                        return
                    }
                    
                    if status == "OK" {
                        routesArray = (((dic["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as? String
                    }

                    DispatchQueue.main.async {
                        print("⚠️Start route planning")
                        let path = GMSPath.init(fromEncodedPath: routesArray!)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 6.0
                        singleLine.strokeColor = AppUIColorBlue
                        singleLine.map = self.gmsMapView
                        
                        if let legs = (((dic["routes"] as? [Any])?[0] as? [String:Any])?["legs"] as? [[String: Any]])  {
//                            var title = ""
//                            print(legs.count)
//                            for i in 0..<(legs.count) {
//                                let d = (legs[i]["duration"] as! [String: Any])["text"] as! String
////                                let origin = (legs[i]["start_address"] as! [String: Any])["text"] as! String
////                                let dest = (legs[i]["end_address"] as! [String: Any])["text"] as! String
//                                title += "Leg\(i), duration: \(d)"
//                            }
                            var title = ""
                            for i in 0..<events.count-1 {
                                let d = (legs[i]["duration"] as! [String: Any])["text"] as! String
                                title += events[i].name + " - " + events[i+1].name + ": " + d + "\n"
                                
                            }
//                            let first = legs[0]
//                            let distance = (first["distance"] as! [String: Any])["text"] as! String
//                            let duration = (first["duration"] as! [String: Any])["text"] as! String
////                            let title = "distance: \(distance) \nduration: \(duration)"
                            print("Route detail：\(title)")

                            let middleIndex = (path?.count() ?? 0)/2
                            if middleIndex > 0 {
                                let location = path?.coordinate(at: middleIndex)
                                let marker = GMSMarker(position: location!)
                                marker.icon = createImage(title, rowInt: events.count-1)
                                marker.map = gmsMapView
                            }
                        }
                    }
                }
            } catch {
                print("request direction error == \(error)")
            }
        }
        task.resume()
    }
    
    func createImage(_ text: String?, rowInt: Int? = 2) -> UIImage {

        let color = UIColor.black
        // select needed color

        // the string to colorize
        let attrs: [NSAttributedString.Key: Any] = [.foregroundColor: color, .font: UIFont.boldSystemFont(ofSize: 12)]
        let attrStr = NSAttributedString(string: text ?? "", attributes: attrs)
        // add Font according to your need
        // let image = UIImage(named: "marker_bubble")!
        // The image on which text has to be added
        let row = Double(rowInt ?? 2)
        let width = 250.0
        let height = 40 * row
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        // image.draw(in: CGRect(x: CGFloat(0), y: CGFloat(0), width: width, height: height))
        let rect = CGRect(x: 0, y: 0, width: width, height: height)

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
