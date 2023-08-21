//
//  RideDetailsViewController.swift
//  Ocory
//
//  Created by Arun Singh on 24/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import  Alamofire

class RideDetailsViewController: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var distance_lbl: UILabel!
    @IBOutlet weak var ride_status_lbl: UILabel!

    
    
    @IBOutlet weak var dateAndTime_lbl: UILabel!
    @IBOutlet weak var amount_lbl: UILabel!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var yourRideWith_lbl: UILabel!
    @IBOutlet weak var paymentStatus_lbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var kDestinationLatLongTap = ""
    var kCurrentLocaLatLongTap = ""

    //MARK:- Variables
    
    var ridesStatusData : RidesData?
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "Ride Details"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.setData()
    }
    
    //MARK:- User Defined Func
    
    func setData(){
        
        self.dateAndTime_lbl.text = self.ridesStatusData?.time ?? ""
        self.amount_lbl.text = "$ " + (self.ridesStatusData?.amount ?? "")
        self.pickUpAddress_lbl.text = self.ridesStatusData?.pickupAdress ?? ""
        self.dropAddress_lbl.text = self.ridesStatusData?.dropAddress ?? ""
        self.paymentStatus_lbl.text = self.ridesStatusData?.paymentStatus ?? ""
        self.yourRideWith_lbl.text = self.ridesStatusData?.driverName ?? ""
        self.distance_lbl.text = (self.ridesStatusData?.distance ?? "") +  " miles"
        self.ride_status_lbl.text = self.ridesStatusData?.status ?? ""

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let lattitude : Double = Double("\(self.ridesStatusData?.pickupLat ?? "")")!
            let longi : Double = Double("\(self.ridesStatusData?.pickupLong ?? "")")!
            
            let camera = GMSCameraPosition.camera(withLatitude:lattitude, longitude:longi, zoom: 5.0)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longi)
            self.mapView.delegate = self
            marker.isDraggable = true
            marker.map = self.mapView
            self.reverseGeocoding(marker: marker)
            self.mapView.animate(to: camera)
        })
    }
}

extension RideDetailsViewController : GMSMapViewDelegate{
    
    //Mark: Reverse GeoCoding
    func reverseGeocoding(marker: GMSMarker) {
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                print("Response Reverse Geocoding is = \(address)")
                print("Response Reverse Geocoding is = \(lines)")
                let lattitude : Double = Double("\(self.ridesStatusData?.dropLat ?? "")")!
                let longi : Double = Double("\(self.ridesStatusData?.dropLong ?? "")")!
                
                    self.kCurrentLocaLatLongTap =   "\(self.ridesStatusData?.pickupLat ?? "")" + "," + "\(self.ridesStatusData?.pickupLong ?? "")"
                
               
                
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
    
    //MARK:- drawing routing line
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
                        
                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 7.0))
                        polyLine.map = self.mapView
                    }
                }
            case .failure(let error): break
                self.showAlert("GetDuma", message: "\(String(describing: error.errorDescription))")
            }
        }
    }
}
