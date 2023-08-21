//
//  HomeViewController.swift
//  Ocory
//
//  Created by Arun Singh on 22/02/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import AVFoundation
import Firebase
import FirebaseDatabase
import MapKit
protocol payRideProtocol {
    func payRide(rideID: String ,amount:String,status:Bool)
}
class HomeViewController: UIViewController {
    //MARK:- OUTLETS
    // @IBOutlet var mainView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickUpAddress_lbl: UILabel!
    @IBOutlet weak var dropAddress_lbl: UILabel!
    @IBOutlet weak var ride_tableView: UITableView!
    @IBOutlet weak var chooseRide_view: SetView!
    @IBOutlet weak var rideNow_btn: SetButton!
    @IBOutlet weak var chooseRideViewHeight_const: NSLayoutConstraint!
    @IBOutlet weak var chooseLbl: UILabel!
    @IBOutlet weak var pickupBtn: UIButton!
    @IBOutlet weak var dropBtn: UIButton!
    @IBOutlet weak var pickupBtnCancel: UIButton!
    @IBOutlet weak var dropBtnCancel: UIButton!
    //MARK:- Variables
    var payRideDelegate: payRideProtocol?
    
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    var toggleState = 1
    var recordSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var settings = [String : Int]()
    var playBtnValue = ""
    var selectRideID = ""
    
    var tap = 0
    var tapOneStatus = false
    var tapTwoStatus = false
    let conn = webservices()
    var getAllVechileData = [VechileData]()
    var rideDistance = ""
    var pickUpLat = ""
    var pickUpLong = ""
    var dropLat = ""
    var dropLong = ""
    var pickUpAddress = ""
    var dropAddress = ""
    var rideAmount = ""
    var locationManager: CLLocationManager!
    var marker = GMSMarker()
    var polyLine = GMSPolyline()
    var update = true
    var profileDetails : ProfileData?
    var locations = [CLLocation]()
    
    var driverConfirmation = driverConfirmStatus.notConfirmed
    var action  =  ""
    var notificationRideId  =  ""
    var driverDistance = ""
    var callDriverStatus = false
    var driverNumber = ""
    var senderDisplayName = ""
    var driverData : userCustomerModal?
    var Dmiles = "0"
    var feedBackStatus = false
    var locationManagerUpdate:Bool = false //Global
    var timer: Timer?
    var newPath = GMSPath()
    private var observer: NSObjectProtocol?
    weak var timerr: Timer?
    var nearByPlacesArray = [[String : Any]]()
    var lastRideData : LastRideModal?
    var lastRideAmount = ""
    var chooseVehicleList = chooseRideList.hide
    var locationPickUpEditStatus =  false
    var locationDropUpEditStatus =  false
    
    var cardData = [cardDataModal]()
    var ref: DatabaseReference!
    var driverLatLNG : String?
    
    var cancellation_charge = String()
    var totalamount = String()
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var popupheight = "full"
    var once = ""
    var pathD = ""
    var speed = Double()
    var timeD = String()
    
    
    var Dtime = 0.0
    var dMarker = GMSMarker()
    //map
     var polyline: GMSPolyline?
    var initialCameraPosition: GMSCameraPosition?

    private var driverAnnotation : MKPointAnnotation?
    
    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
       // appUpdateAvailable()
        updateAppVersionPopup()
        setUpMainFunctions()
        self.registerCell()
        self.setNavButton()
        self.getLocation()
        self.getLastRideDataApi()
        NotificationCenter.default.addObserver(self, selector: #selector(loadBackgroundList), name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForegroundList), name: NSNotification.Name(rawValue: "ReceiveDataForeground1"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Home"
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        DispatchQueue.main.async {
            self.getProfileDataApi()
        }
        DispatchQueue.main.async {
            self.getNearbyDrivers()
        }
        DispatchQueue.main.async {
            self.getLastRideDataApi()
        }
        // self.savedCardApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataBackground1"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("ReceiveDataForeground1"), object: nil)
    }
    // MARK: Check AppVersion
      func updateAppVersionPopup() {
        guard let appStoreURL = URL(string: "http://itunes.apple.com/lookup?bundleId=com.getdumauser.app") else {
            return
        }
        let task = URLSession.shared.dataTask(with: appStoreURL) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results.first?["version"] as? String,
                   let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    
                    if appStoreVersion != currentVersion {
                        DispatchQueue.main.async {
                            self.showUpdatePopup()
                        }
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func showUpdatePopup() {
        let alertController = UIAlertController(title: "New Version Available", message: "Please update to the latest version of the app.", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "Update", style: .default) { (_) in
            guard let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id376771144") else {
                return
            }
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(updateAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }

    //MARK:- Get LAt long
    func getDriverLatLong(driverName:String, RideID :String){
        Timer.scheduledTimer(withTimeInterval: self.Dtime, repeats: false) { timer in
            self.ref = Database.database().reference()
            if driverName != "" && RideID != "" {
                let trimmedString = driverName.trimmingCharacters(in: .whitespaces) + RideID
                self.ref.child("rides").child(trimmedString).child("/" + RideID).observe(.value, with: { snapshot in
                    print(self.ref)
                    guard let dict = snapshot.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    let latitude = dict["latitude"] as? Double
                    let longitude = dict["longitude"] as? Double
                    self.speed = (dict["speedAccuracyMetersPerSecond"] as? Double)!
                    self.driverLatLNG =   "\(latitude ?? 0.0)" + "," + "\(longitude ?? 0.0)"
                    
                    if  self.driverLatLNG != nil{
                        if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" || kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                            
                            self.Dtime = 5.0
                            // self.pathD = "draw"
                            if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE"{
                                self.routingLines(origin: self.driverLatLNG! ,destination: kDestinationLatLongTap)
                                
                            }else{
                                self.routingLines(origin: self.driverLatLNG! ,destination: kCurrentLocaLatLongTap)
                            }
                            
                            CATransaction.begin()
                            CATransaction.setValue(2.0, forKey: kCATransactionAnimationDuration)
                            CATransaction.setCompletionBlock {
                                self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                            }
                            let puppyGif = UIImage(named: "car")
                            let imageView = UIImageView(image: puppyGif)
                            imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
                            self.marker.iconView = imageView
                            self.marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            CATransaction.commit()
                            self.marker.map = self.mapView
                            // Add a car image marker at the starting point
                            let startingLocation = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
                            
                            //                            self.marker.map = nil
                            //                                let puppyGif = UIImage(named: "car")
                            //                                let imageView = UIImageView(image: puppyGif)
                            //                                imageView.frame = CGRect(x: 0, y: 0, width: 45, height: 30)
                            //                                imageView.layer.removeAllAnimations()
                            //                                self.marker = GMSMarker(position: startingLocation)
                            //                                self.marker.iconView = imageView
                            //                                self.marker.map = self.mapView
                            //
                            //                                CATransaction.begin()
                            //                                CATransaction.setAnimationDuration(0.5)
                            //                                self.marker.position = startingLocation
                            //                                CATransaction.commit()
                            
                            
                        }
                    }
                    self.CheckDistance(lat: latitude!, lng: longitude!)
                    
                })
            }
        }
    }
    
    
    func CheckDistance(lat:Double, lng: Double){
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)

            let currentLocationLat = currentLocation.coordinate.latitude as! Double
            let currentLocationLng = currentLocation.coordinate.longitude as! Double

            let coordinate₀ = CLLocation(latitude: lat, longitude: lng)
            let coordinate₁ = CLLocation(latitude: currentLocationLat, longitude: currentLocationLng)


            let distanceInMeters = coordinate₀.distance(from: coordinate₁)
            let distanceinmiles = distanceInMeters * 0.000621371192
            let y = Double(round(100 * distanceinmiles) / 100)
            print(y) /// 1.236
            self.Dmiles = String(y)
            let distanceInKilometers = distanceInMeters / 1000.0
            
            if self.speed > 5.00{
                let averageSpeedKilometersPerHour = self.speed * 3.6
                let estimatedTimeHours = distanceInKilometers / averageSpeedKilometersPerHour
                let estimatedTimeMinutes = estimatedTimeHours * 60.0
                let estimatedTimeMinutesWithoutDecimal = Int(estimatedTimeMinutes)
                self.timeD = String(estimatedTimeMinutesWithoutDecimal)
            }else{
                let averageSpeedKilometersPerHour: CLLocationSpeed = 60.0
                let estimatedTimeHours = distanceInKilometers / averageSpeedKilometersPerHour
                let estimatedTimeMinutes = estimatedTimeHours * 60.0
                let estimatedTimeMinutesWithoutDecimal = Int(estimatedTimeMinutes)
                self.timeD = String(estimatedTimeMinutesWithoutDecimal)
            }
            
            if distanceinmiles <= 0.12{
              //  self.timeD = "1 min"
                if distanceinmiles <= 0.1{
                    self.timeD = "0"
                }
                if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" && kRideId != "" {
                    if once != "done"{
                        self.once = "done"
                        DispatchQueue.main.async {
                            self.ride_tableView.reloadData()
                        }
                        let alert = UIAlertController(title: "GetDuma", message: "Driver has arrived at your location. Please meet with your driver.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                            self.once = "done"
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.ride_tableView.reloadData()
                }
            }
        }
    }
    func geocodeAddress(address: String, completion: @escaping (Result<(latitude: Double, longitude: Double), Error>) -> Void) {
        let apiKey = "AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4" // Replace with your own Google Maps API key
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(encodedAddress)&key=\(apiKey)"
        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]],
                   let location = results.first?["geometry"] as? [String: Any],
                   let latitude = location["lat"] as? Double,
                   let longitude = location["lng"] as? Double {
                    completion(.success((latitude: latitude, longitude: longitude)))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func calculateEstimatedDrivingTime(fromAddress: String, toAddress: String) {
        geocodeAddress(address: fromAddress) { result in
            switch result {
            case .success(let fromLocation):
                self.geocodeAddress(address: toAddress) { result in
                    switch result {
                    case .success(let toLocation):
                        let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fromLocation.latitude, longitude: fromLocation.longitude))
                        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: toLocation.latitude, longitude: toLocation.longitude))
                        
                        let request = MKDirections.Request()
                        request.transportType = .automobile
                        request.source = MKMapItem(placemark: sourcePlacemark)
                        request.destination = MKMapItem(placemark: destinationPlacemark)
                        
                        let directions = MKDirections(request: request)
                        directions.calculate { (response, error) in
                            guard let response = response else {
                                if let error = error {
                                    print("Error calculating directions: \(error.localizedDescription)")
                                }
                                return
                            }
                            
                            if let route = response.routes.first {
                                let estimatedTimeInSeconds = route.expectedTravelTime
                                let estimatedTimeInMinutes = estimatedTimeInSeconds / 60
                                print("Estimated driving time: \(estimatedTimeInMinutes) minutes")
                            }
                        }
                    case .failure(let error):
                        print("Error geocoding to address: \(error)")
                    }
                }
            case .failure(let error):
                print("Error geocoding from address: \(error)")
            }
        }
    }


    @objc func failedTimer(_ timer: Timer){
        print("Failded Timer Start")
        var timerCountStatus = false
        if kRideId != "" && timerCountStatus == true {
            print("work 3 minutes more")
            timerCountStatus = false
        }
        if kRideId != "" && timerCountStatus == false {
            print("work 3 minutes")
            timerCountStatus = true
            if  kNotificationAction == "PENDING" && kConfirmationAction == "PENDING" {
                self.cancelRideStatus(rideId: kRideId)
            }
        }
    }
   
}
    

//MARK:- =====OTHER FUNCTIONS=========

//extension HomeViewController : MKMapViewDelegate {
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////        if !(annotation is MKPointAnnotation) {
////            return nil
////        }
////        let annotationIdentifier = "AnnotationIdentifier"
////        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
////
////        if annotationView == nil {
////            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
////            annotationView!.canShowCallout = true
////        }
////        else {
////            annotationView!.annotation = annotation
////        }
////        let pinImage = UIImage(named: "ic_driver")
////        annotationView!.image = pinImage
////        return annotationView
////    }
//
//
//
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        self.mapView.setRegion(region, animated: true)
//    }
//}
extension HomeViewController {
    //MARK:- User Defined Func
    func getLocation() {
      //  self.mapView.isMyLocationEnabled = true
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
      //  locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            locationManager.startUpdatingLocation()
        }
    }
    func registerCell(){
        let sideMenuNib = UINib(nibName: "SideMenuTableViewCell", bundle: nil)
        self.ride_tableView.register(sideMenuNib, forCellReuseIdentifier: "SideMenuTableViewCell")
        
        let confirmationNib = UINib(nibName: "DriverConfirmationCell", bundle: nil)
        self.ride_tableView.register(confirmationNib, forCellReuseIdentifier: "DriverConfirmationCell")
        
        let callDriverNib = UINib(nibName: "CallDriverCell", bundle: nil)
        self.ride_tableView.register(callDriverNib, forCellReuseIdentifier: "CallDriverCell")
        
        let rideOnWaydNib = UINib(nibName: "RideOnWayCell", bundle: nil)
        self.ride_tableView.register(rideOnWaydNib, forCellReuseIdentifier: "RideOnWayCell")
        
        let rideCompletedNib = UINib(nibName: "RideCompletedCell", bundle: nil)
        self.ride_tableView.register(rideCompletedNib, forCellReuseIdentifier: "RideCompletedCell")
        
        let paymentNib = UINib(nibName: "PaymentPopUpVCCell", bundle: nil)
        self.ride_tableView.register(paymentNib, forCellReuseIdentifier: "PaymentPopUpVCCell")
        
        self.ride_tableView.dataSource = self
        self.ride_tableView.delegate = self

    }

    func scheduledTimerWithTimeInterval(){
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateLocationManager), userInfo: nil, repeats: true)
    }
    @objc func updateLocationManager() {
        if locationManagerUpdate == false {
            locationManager.delegate = self
            locationManagerUpdate = true
        }
    }
    
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            if #available(iOS 14.0, *) {
                switch manager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    hasPermission = false
                case .authorizedAlways, .authorizedWhenInUse:
                    hasPermission = true
                @unknown default:
                    break
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            hasPermission = false
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return hasPermission
    }
    //MARK:- set up userid and fcm token
    func setUpMainFunctions(){
        if let savedPeople = UserDefaults.standard.object(forKey: "loginInfo") as? Data {
            if let decodedPeople = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPeople) as? [String: Any] {
           //     print(decodedPeople)
                if let user_id = decodedPeople["user_id"] as? String {
                    NSUSERDEFAULT.set(user_id, forKey: kUserID)
                    kDriverId = kUserID
                }
                if let fcm = decodedPeople["gcm_token"] as? String {
                    NSUSERDEFAULT.set(fcm, forKey: kFcmToken)
                    print("GCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
                }
//                if let email = decodedPeople["email"] as? String {
//                    NSUSERDEFAULT.set(email, forKey: kEmail)
//                    print("EMAIL IS HERE \(NSUSERDEFAULT.value(forKey: kEmail) ?? "")")
//
//                }
//                if let name = decodedPeople["name"] as? String {
//                    NSUSERDEFAULT.set(name, forKey: kName)
//                    print("NAME IS HERE \(NSUSERDEFAULT.value(forKey: kName) ?? "")")
//                }
            }
        }
        print("ACCESS TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: accessToken) ?? "")")
        print("FCM TOKEN IS HERE \(NSUSERDEFAULT.value(forKey: kFcmToken) ?? "")")
        print(action)
        print(kRideId)
        print(senderDisplayName)
    }
    // Present the Autocomplete view controller when the button is pressed.
    func autocompleteClicked() {
        marker.map = nil
        polyLine.map = nil
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
      //  let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue))!
       // autocompleteController.placeFields = fields
//        let filter = GMSAutocompleteFilter()
//        filter.type = .address
//        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
}
