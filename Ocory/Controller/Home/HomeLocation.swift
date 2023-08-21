//
//  HomeLocation.swift
//  Ocory
//
//  Created by nile on 06/07/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire

//MARK:- Google Places Delegate
extension HomeViewController: GMSAutocompleteViewControllerDelegate ,GMSMapViewDelegate {
//    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
//        print("Primary: \(prediction.attributedPrimaryText ?? "")")
//        print("Secondary: \(prediction.attributedSecondaryText ?? "")")
//        
//        
//        return false;
//    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  GMSPlaceField.addressComponents.rawValue |
                                                  GMSPlaceField.formattedAddress.rawValue)!
        //   autocompleteController.placeFields = fields
        viewController.placeFields = fields
        if tap == 1{
            kCurrentAddressMarker = ""
            tapOneStatus = true
            tapTwoStatus = false
            self.pickUpLong = String(describing: place.coordinate.longitude)
            self.pickUpLat = String(describing: place.coordinate.latitude)
            self.pickUpAddress = place.name ?? ""
            
            DispatchQueue.main.async {
                NavigationManager.pushToLoginVC(from: self)
            }
            let addressComponents = place.addressComponents
            
            var fullAddress = ""
            if  place.name != nil{
                fullAddress += place.name! + ", "
            }
            for component in addressComponents! {
                let addressType = component.types[0]
                if addressType == "street_number" || addressType == "route" {
                    fullAddress += component.name + ", "
                }else if addressType == "sublocality_level_2" || addressType == "sublocality" {
                    fullAddress += component.name + ", "
                }else if addressType == "sublocality_level_1" || addressType == "sublocality" {
                    fullAddress += component.name + ", "
                } else if addressType == "locality" || addressType == "administrative_area_level_1" {
                    fullAddress += component.name + ", "
                } else if addressType == "postal_code" {
                    fullAddress += component.name + ", "
                } else if addressType == "country" {
                    fullAddress += component.name
                }
            }
            
            // Set the full address in the text field
            //   addressTextField.text = fullAddress
            
            self.pickUpAddress_lbl.text = place.formattedAddress
            self.getNearbyDrivers()
            self.chooseRide_view.isHidden = true
            print("Pickup Latitude is ===\(place.coordinate.latitude)")
            print("Pickup Longitude is ===\(place.coordinate.longitude)")
            kPickLatTap = "\(place.coordinate.latitude)"
            kPickLongTap = "\(place.coordinate.longitude)"
            kPickUpLatFinal = "\(place.coordinate.latitude)"
            kPickUpLongFinal = "\(place.coordinate.longitude)"
            kCurrentLocaLatLongTap =   "\(place.coordinate.latitude)" + "," + "\(marker.position.longitude)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                print("1Pickup Latitude is ===\(place.coordinate.latitude)")
                print("1Pickup Longitude is ===\(place.coordinate.longitude)")
                //  self.convertLatLongToAddress(latitude:place.coordinate.latitude , longitude: place.coordinate.longitude)
                //self.reverseGeocodingPickUp(marker: marker)
                if self.pathD != "draw"{
                    let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 13.0)
                    self.mapView.animate(to: camera)
                }
                
                let markerPickup = GMSMarker()
                //   markerPickup.icon = GMSMarker.markerImage(with: UIColor.black)
                markerPickup.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.mapView.delegate = self
                //   marker.isDraggable = true
                markerPickup.title = kCurrentAddressMarker
                markerPickup.map = self.mapView
                
            })
        }else{
            kDropAddressMarker = ""
            tapTwoStatus = true
            kDestinationLatLong = "\(place.coordinate.latitude)" + "," + "\(place.coordinate.longitude)"
            self.dropLat = String(describing: place.coordinate.latitude)
            self.dropLong = String(describing: place.coordinate.longitude)
            self.dropAddress = place.name ?? ""
            
            kDropLat = "\(place.coordinate.latitude)"
            kDropLong = "\(place.coordinate.longitude)"
            print("Drop Latitude is ===\(place.coordinate.latitude)")
            print("Drop Longitude is ===\(place.coordinate.longitude)")
            kDestinationLatLongTap =   "\(place.coordinate.latitude)" + "," + "\(place.coordinate.longitude)"
            self.dropAddress = place.name ?? ""
            
            let addressComponents = place.addressComponents
            
            var fullAddress = ""
            if  place.name != nil{
                fullAddress += place.name! + ", "
            }
            for component in addressComponents! {
                let addressType = component.types[0]
                if addressType == "street_number" || addressType == "route" {
                    fullAddress += component.name + ", "
                }else if addressType == "sublocality_level_2" || addressType == "sublocality" {
                    fullAddress += component.name + ", "
                }else if addressType == "sublocality_level_1" || addressType == "sublocality" {
                    fullAddress += component.name + ", "
                } else if addressType == "locality" || addressType == "administrative_area_level_1" {
                    fullAddress += component.name + ", "
                } else if addressType == "postal_code" {
                    fullAddress += component.name + ", "
                } else if addressType == "country" {
                    fullAddress += component.name
                }
            }
            
            // Set the full address in the text field
            //   addressTextField.text = fullAddress
            
            self.dropAddress_lbl.text = place.formattedAddress
            
            //   self.dropAddress_lbl.text = place.name ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                //  self.convertLatLongToAddressDrop(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                
                //  self.dropAddress_lbl.text =  addressString
                self.locationDropUpEditStatus = true
                kDropAddressMarker = fullAddress
                kDropAddress = fullAddress
                if self.pathD != "draw"{
                    let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 13.0)
                    self.mapView.animate(to: camera)
                }
                let marker = GMSMarker()
                // marker.icon = GMSMarker.markerImage(with: UIColor.green)
                marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                self.mapView.delegate = self
                marker.isDraggable = true
                marker.map = self.mapView
                // self.reverseGeocodingDropUp(marker: marker)
                if kCurrentLocaLatLongTap != "" && kDestinationLatLongTap != ""{
                    if self.tapOneStatus || self.tapTwoStatus == true{
                        self.chooseRide_view.isHidden = false
                        self.routingLines(origin: kCurrentLocaLatLongTap,destination: kDestinationLatLongTap)
                        self.getVechileTypeApi()
                    }
                }
                
            })
        }
        dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    //Mark: Marker methods
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        // reverseGeocoding(marker: marker)
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    //Mark: Reverse GeoCoding
//    func reverseGeocodingPickUp(marker: GMSMarker) {
//        locationPickUpEditStatus = true
//        let geocoder = GMSGeocoder()
//        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
//        var currentAddress = String()
//        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
//            if let address = response?.firstResult() {
//                let lines = address.lines! as [String]
//                print("Response Reverse Geocoding is = \(address)")
//                print("Response Reverse Geocoding is = \(lines)")
//                kPickUpLatFinal = String(describing: marker.position.latitude)
//                kPickUpLongFinal = String(describing: marker.position.longitude)
//                kPickLatTap = String(describing: marker.position.latitude)
//                kPickLongTap = String(describing: marker.position.longitude)
//                currentAddress = lines.joined(separator: "\n")
//
//                DispatchQueue.main.async {
//                    NavigationManager.pushToLoginVC(from: self)
//                }
//                self.pickUpAddress_lbl.text = currentAddress
//
//                kCurrentLocaLatLongTap =   "\(marker.position.latitude)" + "," + "\(marker.position.longitude)"
//                marker.title = currentAddress
//                marker.map = self.mapView
//                //                    kDestinationLatLongTap =   "\(marker.position.latitude)" + "," + "\(marker.position.longitude)"
//                //                    marker.title = currentAddress
//                //                    marker.map = self.mapView
//            }
//        }
//    }
//    func reverseGeocodingDropUp(marker: GMSMarker) {
//        locationDropUpEditStatus = true
//        let geocoder = GMSGeocoder()
//        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
//        var currentAddress = String()
//
//        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
//            if let address = response?.firstResult() {
//                let lines = address.lines! as [String]
//                print("Response Reverse Geocoding is = \(address)")
//                print("Response Reverse Geocoding is = \(lines)")
//                currentAddress = lines.joined(separator: "\n")
//                kDropAddress = currentAddress
//                kDestinationLatLongTap =   "\(marker.position.latitude)" + "," + "\(marker.position.longitude)"
//                marker.title = currentAddress
//                print(kDropAddress)
//                DispatchQueue.main.async {
//                    NavigationManager.pushToLoginVC(from: self)
//                }
//                self.dropAddress_lbl.text = kDropAddress
//                marker.map = self.mapView
//                if kCurrentLocaLatLongTap != "" && kDestinationLatLongTap != ""{
//                    if self.tapOneStatus || self.tapTwoStatus == true{
//                        self.chooseRide_view.isHidden = false
//                        self.routingLines(origin: kCurrentLocaLatLongTap,destination: kDestinationLatLongTap)
//                        self.getVechileTypeApi()
//                    }
//                }
//            }
//        }
//    }
    func reverseGeocodingCurrent(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response Geocoding is = \(address)")
                print("Response Geocoding is = \(lines)")
                currentAddress = lines.joined(separator: "\n")
                
                DispatchQueue.main.async {
                    NavigationManager.pushToLoginVC(from: self)
                }
                self.pickUpAddress_lbl.text = currentAddress
                marker.title = currentAddress
                marker.map = self.mapView
            }
        }
    }
    func routingLines(origin: String,destination: String){
        print("PICK UP LAT LONG======\(origin)")
        print("DROP LAT LONG======\(destination)")
        
        let googleapi =  "AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
        AF.request(url).responseJSON {_ in
            print("PICK UP LAT LONG======\(origin)")
            print("DROP LAT LONG======\(destination)")
            
            let googleapi =  "AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4"
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
            AF.request(url).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? [String: Any],
                          let routes = json["routes"] as? [[String: Any]],
                          let route = routes.first,
                          let polyline = route["overview_polyline"] as? [String: Any],
                          let points = polyline["points"] as? String
                    else {
                        // Handle parsing error or invalid response
                        return
                    }
                    
                    // Decode the polyline points
                    let path = GMSPath(fromEncodedPath: points)
                    
                    // Remove existing polyline from the map if it exists
                    self.polyline?.map = nil
                    
                    // Create a new GMSPolyline and add it to the map
                    let newPolyline = GMSPolyline(path: path)
                    newPolyline.strokeColor = .black
                    newPolyline.strokeWidth = 3
                    newPolyline.map = self.mapView
                    
                    // Assign the new polyline to the variable
                    self.polyline = newPolyline
                    
                    
                    // Adjust the camera to fit the polyline
                    let bounds = GMSCoordinateBounds(path: path!)
                    let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                    self.mapView.animate(with: update)
                    
                    
                    
                    //                    // Adjust the camera to fit the polyline
                    //                    let bounds = GMSCoordinateBounds(path: path!)
                    //                    let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                    //                    self.mapView.animate(with: update)
                    
                case .failure(let error):
                    // Handle error
                    print("Error: \(error)")
                }
            }
        }
//        }{ response in
//            switch response.result {
//            case .success(let value):
//                if let JSON = value as? [String: Any] {
//                    let routes = JSON["routes"] as! NSArray
//                    for route in routes
//                    {
//                        self.polyLine.map = nil
//                       // self.mapView.clear()
//                        let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
//                        let paths : NSArray = pathv.value(forKey: "points") as! NSArray
//                        let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
//                     //   let polyLine = GMSPolyline(path: newPath)
//                        self.polyLine.strokeWidth = 3
//                        self.polyLine.strokeColor = .black
//                        let ThemeOrange = GMSStrokeStyle.solidColor( .black)
//                        let OrangeToBlue = GMSStrokeStyle.gradient(from:  .black, to:  .black)
//                        self.polyLine.spans = [GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: ThemeOrange),
//                                          GMSStyleSpan(style: OrangeToBlue)]
//                        let bounds = GMSCoordinateBounds(path:newPath! )
//                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 7.0))
//                        self.polyLine.map = self.mapView
//                    }
//                }
//            case .failure(let error): break
//                self.showAlert("GetDuma", message: "\(String(describing: error.errorDescription))")
//            }
//        }
    }
    func convertStringToCoordinates(_ coordinatesString: String) -> CLLocationCoordinate2D? {
        let coordinateComponents = coordinatesString.components(separatedBy: ",")
        guard coordinateComponents.count == 2,
              let latitude = Double(coordinateComponents[0]),
              let longitude = Double(coordinateComponents[1]) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
//    func snapToRoads(coordinates: [CLLocationCoordinate2D], completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
//        let googleAPI = "AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4"
//
//        let coordinateStrings = coordinates.map { "\($0.latitude),\($0.longitude)" }
//        let path = coordinateStrings.joined(separator: "|")
//
//        let url = "https://roads.googleapis.com/v1/snapToRoads?path=\(path)&interpolate=true&key=\(googleAPI)"
//
//        AF.request(url).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                let snappedPoints = json["snappedPoints"].arrayValue
//
//                let snappedCoordinates = snappedPoints.compactMap { (result) -> CLLocationCoordinate2D? in
//                    let location = result["location"]
//                    let latitude = location["latitude"].doubleValue
//                    let longitude = location["longitude"].doubleValue
//
//                    return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//                }
//
//                completion(snappedCoordinates)
//
//            case .failure(let error):
//                print("Error snapping to roads: \(error)")
//                completion([])
//            }
//        }
//    }
}
//MARK:- Get User Location
extension HomeViewController: CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.last! as CLLocation
//        if self.update == true{
//        kPickLatTap = "\(location.coordinate.latitude)"
//        kPickLongTap = "\(location.coordinate.longitude)"
//            NSUSERDEFAULT.setValue("\(location.coordinate.latitude)", forKey: kCurrentLat)
//            NSUSERDEFAULT.setValue("\(location.coordinate.longitude)", forKey: kCurrentLong)
//            kCurrentLocaLatLong = "\(location.coordinate.latitude)" + "," + "\(location.coordinate.longitude)"
//            kCurrentLocaLat   = "\(location.coordinate.latitude)"
//            kCurrentLocaLatLongTap = "\(location.coordinate.latitude)" + "," + "\(location.coordinate.longitude)"
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13.0)
//                let marker = GMSMarker()
//                marker.position = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//                self.mapView.delegate = self
//                self.mapView.isMyLocationEnabled = false
//                self.mapView.settings.myLocationButton = false
//                marker.map = self.mapView
//                marker.isDraggable = true
//              //  self.reverseGeocodingCurrent(marker: marker)
//                self.mapView.animate(to: camera)
//            })
//        }
//
//    }
//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
        let geocoder = CLGeocoder()
        if self.update == true{
            kPickLatTap = "\(location.coordinate.latitude)"
            kPickLongTap = "\(location.coordinate.longitude)"
            NSUSERDEFAULT.setValue("\(location.coordinate.latitude)", forKey: kCurrentLat)
            NSUSERDEFAULT.setValue("\(location.coordinate.longitude)", forKey: kCurrentLong)
            kCurrentLocaLatLong = "\(location.coordinate.latitude)" + "," + "\(location.coordinate.longitude)"
            kCurrentLocaLat   = "\(location.coordinate.latitude)"
            kCurrentLocaLong   = "\(location.coordinate.longitude)"
            kCurrentLocaLatLongTap = "\(location.coordinate.latitude)" + "," + "\(location.coordinate.longitude)"
            self.convertLatLongToAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            kPickUpLatFinal = "\(location.coordinate.latitude)"
            kPickUpLongFinal = "\(location.coordinate.longitude)"
//            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
//                if error == nil{
//                    if ((placemark?.count ?? 0) > 0){
//                        let placemark = placemark?.first
//                        print( "location is here==\(placemark?.locality as Any)")
//                        self.pickUpAddress_lbl.text = placemark?.subLocality ?? ""
//                        kCurrentLocaLatLong = "\(myLocation.latitude)" + "," + "\(myLocation.longitude)"
//                        kCurrentLocaLat   = "\(myLocation.latitude)"
//                        kCurrentLocaLong = "\(myLocation.longitude)"
//
//
//
//                    }
//                }
//            }
            if self.pathD != "draw"{
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13.0)
                self.mapView.camera = camera
            }
            self.mapView.settings.myLocationButton = true
            // Creates a marker in the center of the map.
            marker.map = self.mapView
            self.update = false
        }
    }
    
    func convertLatLongToAddress(latitude:Double, longitude:Double) {
        locationPickUpEditStatus = true

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]

            if placeMark != nil {
                var addressString : String = ""
                if (placeMark.subThoroughfare != nil) {
                    addressString = addressString + placeMark.subThoroughfare! + ", "
                }
                if placeMark.thoroughfare != nil {
                    addressString = addressString + placeMark.thoroughfare! + ", "
                }
                if placeMark.subLocality != nil {
                    addressString = addressString + placeMark.subLocality! + ", "
                }
                if placeMark.locality != nil {
                    addressString = addressString + placeMark.locality! + ", "
                }
                if placeMark.country != nil {
                    addressString = addressString + placeMark.country! + ", "
                }
                if placeMark.postalCode != nil {
                    addressString = addressString + placeMark.postalCode! + " "
                }
                print(addressString)
                self.pickUpAddress_lbl.text =  addressString
                self.getNearbyDrivers()
                kCurrentAddressMarker = addressString
                print(placeMark.country as Any)
                print(placeMark.locality as Any)
                print(placeMark.subLocality as Any)
                print(placeMark.thoroughfare as Any)
                print(placeMark.postalCode as Any)
                print(placeMark.subThoroughfare as Any)
                
                print("CURRENT ADDRESS IS HERE==\(addressString)")
                // labelText gives you the address of the place
            }
        })
    }
    
    
    func convertLatLongToAddressDrop(latitude:Double, longitude:Double) {
        locationDropUpEditStatus = true
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in

            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if placeMark != nil{
                var addressString : String = ""
                if placeMark.thoroughfare != nil {
                    addressString = addressString + placeMark.thoroughfare! + ", "
                }
                if placeMark.subThoroughfare != nil {
                    addressString = addressString + placeMark.subThoroughfare! + ", "
                }
                if placeMark.administrativeArea != nil {
                    addressString = addressString + placeMark.administrativeArea! + ", "
                }
                if placeMark.subLocality != nil {
                    addressString = addressString + placeMark.subLocality! + ", "
                }
                if placeMark.locality != nil {
                    addressString = addressString + placeMark.locality! + ", "
                }
                if placeMark.country != nil {
                    addressString = addressString + placeMark.country! + ", "
                }
                if placeMark.postalCode != nil {
                    addressString = addressString + placeMark.postalCode! + " "
                }
                print(addressString)
                DispatchQueue.main.async {
                    NavigationManager.pushToLoginVC(from: self)
                }
                self.dropAddress_lbl.text =  addressString
                kDropAddressMarker = addressString
                kDropAddress = addressString
                print(kDropAddressMarker)
                print(placeMark.country as Any)
                print(placeMark.locality as Any)
                print(placeMark.subLocality as Any)
                print(placeMark.thoroughfare as Any)
                print(placeMark.postalCode as Any)
                print(placeMark.subThoroughfare as Any)
                
                print("DROP ADDRESS IS HERE==\(addressString)")
                // labelText gives you the address of the place
            }
        })
    }
}

