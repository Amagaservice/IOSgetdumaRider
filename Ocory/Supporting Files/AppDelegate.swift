//
//  AppDelegate.swift
//  Ocory
//
//  Created by Arun Singh on 2/1/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SDWebImage
import IQKeyboardManager
import CoreLocation
import Firebase
import FirebaseMessaging
import UserNotifications
import UserNotificationsUI
import Stripe

 @main
class AppDelegate: UIResponder, UIApplicationDelegate{
    static var fcmToken: String?
    var recentToken = Data()
    var locationManager:CLLocationManager!
    let gcmMessageId = "ocaryCustomer.app"
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AIzaSyDLAHWiWMZsT6uoevKBejTU-gn6vxcczJQ
        //  AIzaSyALNQ0K_N0bjPk2YfL2b_hoPt63aW9k9qc
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        IQKeyboardManager.shared().isEnabled = true
//        GMSServices.provideAPIKey("AIzaSyB-JC40RpeU21Ho_ex_olOh-7Cyi-IuIfQ")
//        GMSPlacesClient.provideAPIKey("AIzaSyDLAHWiWMZsT6uoevKBejTU-gn6vxcczJQ")
        
        
        // Old key 22/07/22
//        GMSServices.provideAPIKey("AIzaSyDJdca6mIsb_mOadvjvTMk9VHXtNFrO-58")
//        GMSPlacesClient.provideAPIKey("AIzaSyDJdca6mIsb_mOadvjvTMk9VHXtNFrO-58")

        
        // new key
        GMSServices.provideAPIKey("AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4")
        GMSPlacesClient.provideAPIKey("AIzaSyAJuI_IDQB0lt10U0Obffdr0qFV1soIMh4")
//        GMSServices.provideAPIKey("AIzaSyBMLBSHLJ5w-DXl7pXmIWp0zi4eW8gMvls")
//              GMSPlacesClient.provideAPIKey("AIzaSyBMLBSHLJ5w-DXl7pXmIWp0zi4eW8gMvls")
        
        self.locationManager = CLLocationManager()
       // locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        /************************************************************************************************
                                                Development Key
        *************************************************************************************************/
        
   //     STPAPIClient.shared.publishableKey = "pk_test_4sjCZIFhfIeMDj3bpJsFapZf"
       // STPAPIClient.shared.publishableKey = "pk_test_51JfQPASIMdyczcfqdSQAp1CVfeY9hQOtJVyHqa6gp2RScnW72x8bFBCk1i5239fCRvBQWw4Vqn8bluN8o3elSFOJ00CQFREoso"
        
        /************************************************************************************************
                                                Production Key
        *************************************************************************************************/
        
       // STPAPIClient.shared.publishableKey = "pk_live_51JfQPASIMdyczcfq6l4RPYFomtlLdJrenDvxcKG6f4mqgdwmgmQr9YkJMp6hJ9Zr6nKnvovUPGyQ5Z0v0p5G6EKt00JfihnULO"
        
        
        // stripe new test key
        STPAPIClient.shared.publishableKey = "pk_test_51LAbxjF7fyWOMuNtMyMiQjWkq1LhNujhjMNEyHRZJCqtEr5VUgO5RsBqCsp21nuf4x9tlEWzumqjJdWn2l5t9JU400veD5UgFy"

        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
extension AppDelegate :  CLLocationManagerDelegate
{
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ())  {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)) { completion($0?.first, $1) }
    }

    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error Location")
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        //Access the last object from locations to get perfect current location
        if let location = locations.last {

            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            kCurrentLocaLat = "\(location.coordinate.latitude)"
            kCurrentLocaLong = "\(location.coordinate.longitude)"
            NSUSERDEFAULT.setValue("\(myLocation.latitude)", forKey: kCurrentLat)
            NSUSERDEFAULT.setValue("\(myLocation.longitude)", forKey: kCurrentLong)

            geocode(latitude: myLocation.latitude, longitude: myLocation.longitude) { placemark, error in
                guard let placemark = placemark, error == nil else { return }
                // you should always update your UI in the main thread
                DispatchQueue.main.async {
                    //  update UI here
                    
                    print("address1:", placemark.thoroughfare ?? "")
                    print("address2:", placemark.subThoroughfare ?? "")
                    print("city:",     placemark.locality ?? "")
                    print("state:",    placemark.administrativeArea ?? "")
                    print("zip code:", placemark.postalCode ?? "")
                    print("country:",  placemark.country ?? "")
                    let defaults = UserDefaults.standard
                    let dict = ["address1": placemark.thoroughfare ?? "", "address2": placemark.subThoroughfare ?? "" ,"city" : placemark.locality ?? "","state": placemark.administrativeArea ?? "", "zip code" : placemark.postalCode ?? "","country" : placemark.country ?? "" , "latitude" : myLocation.latitude , "longitude" : myLocation.longitude ] as [String : Any]
                    defaults.set(dict, forKey: "SavedCurrentLocation")
                    
                }
            }
        }
        manager.stopUpdatingLocation()

    }
}
extension AppDelegate : MessagingDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print(deviceTokenString)
        recentToken = deviceToken
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        NSUSERDEFAULT.setValue(fcmToken, forKey: kFcmToken)

         let dataDict: [String: String] = ["token": fcmToken ?? ""]
         NotificationCenter.default.post(
           name: Notification.Name("FCMToken"),
           object: nil,
           userInfo: dataDict
         )
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("Received data message: \(remoteMessage.description)")
    }
    
}
@available(iOS 10, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
        let userInfo = notification.request.content.userInfo
     //   NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil , userInfo: userInfo)
        
        let state = UIApplication.shared.applicationState
        if state == .active {
            // foreground alertRemoteNotification(request.content.userInfo as NSDictionary) }
            print("willPresent Method\(userInfo)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataBackground1"), object: nil , userInfo: userInfo)
           // completionHandler(<#UNNotificationPresentationOptions#>)
            completionHandler([.alert, .badge, .sound])
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        completionHandler(.newData)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReceiveDataForeground1"), object: nil , userInfo: userInfo)
        completionHandler()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
    }
}

