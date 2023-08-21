//
//  MySpendCell.swift
//  Ocory
//
//  Created by nile on 29/07/22.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire

class MySpendCell: UITableViewCell {
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!

    @IBOutlet weak var pickUpLocation_lbl: UILabel!
    @IBOutlet weak var dropLocation_lbl: UILabel!
    
    @IBOutlet weak var mapView: GMSMapView!
    var kDestinationLatLongTap = ""
    var kCurrentLocaLatLongTap = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.isUserInteractionEnabled = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MySpendCell : GMSMapViewDelegate{
    
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker , lat : String ,long :String,pickupLat :String ,pickupLong :String) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response Reverse Geocoding is = \(address)")
                print("Response Reverse Geocoding is = \(lines)")
                let lattitude : Double = Double("\(lat)")!
                let longi : Double = Double("\(long)")!
                self.kCurrentLocaLatLongTap =   "\(pickupLat)" + "," + "\(pickupLong)"
                currentAddress = lines.joined(separator: "\n")
                self.kDestinationLatLongTap =   "\(lattitude)" + "," + "\(longi)"
                marker.title = currentAddress
                marker.map = self.mapView
                if self.kCurrentLocaLatLongTap != "" && self.kDestinationLatLongTap != ""{
                    self.routingLines(origin: self.kCurrentLocaLatLongTap,destination: self.kDestinationLatLongTap)
                }
            }
        }
    }
    
    func routingLines(origin: String,destination: String){
        print("PICK UP LAT LONG======\(origin)")
        print("DROP LAT LONG======\(destination)")
        
        let googleapi =  "AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let JSON = value as? [String: Any] {
                    let routes = JSON["routes"] as! NSArray
                    for route in routes
                    {
                        let pathv : NSArray = routes.value(forKey: "overview_polyline") as! NSArray
                        let paths : NSArray = pathv.value(forKey: "points") as! NSArray
                        let newPath = GMSPath.init(fromEncodedPath: paths[0] as! String)
                        let polyLine = GMSPolyline(path: newPath)
                        polyLine.strokeWidth = 5
                        polyLine.strokeColor =  .black
                        let ThemeOrange = GMSStrokeStyle.solidColor( .blue)
                        let OrangeToBlue = GMSStrokeStyle.gradient(from:  .blue, to:  .blue)
                        polyLine.spans = [GMSStyleSpan(style: ThemeOrange),
                                          GMSStyleSpan(style: ThemeOrange),
                                          GMSStyleSpan(style: OrangeToBlue)]
                        let bounds = GMSCoordinateBounds(path:newPath! )
                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 2.0))
                        polyLine.map = self.mapView
                    }
                }
            case .failure(let error): break
              //  self.showAlert("GetDuma", message: "\(String(describing: error.errorDescription))")
                print(error)
            }
        }
    }
}
