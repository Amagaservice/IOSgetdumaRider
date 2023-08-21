//
//  HomeButton.swift
//  Ocory
//
//  Created by nile on 09/07/21.
//

import UIKit
import AVFoundation
import Alamofire
extension HomeViewController {
    //MARK:- Button Action

    @objc func loadBackgroundList(_ notification: NSNotification){
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                kConfirmationAction = dictData
                if let dictDataRideID = dict["ride_id"] as? String{
                    kRideId = (dict["ride_id"] as? String)!
                    getLastRideDataApi()
                    print(dictDataRideID)
                }
                if kNotificationAction == "ACCEPTED"{
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "COMPLETED"  {
                    if dict["is_technical_issue"] as? String == "Yes"{
                        let refreshAlert = UIAlertController(title: "GetDuma", message: "Driver wants to drop off you before \n reaching destination. Do you want to complete this ride?", preferredStyle: UIAlertController.Style.alert)
                        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                            let refreshAlert = UIAlertController(title: "GetDuma", message: "Payment is automatically debit for this ride.", preferredStyle: UIAlertController.Style.alert)

                            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                               // print("autoPAyment")
                                self.savedCardApi()
                            }))
                            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                                refreshAlert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            
                        }))
                        // "Driver NOT wants to drop off you before \n reaching destination. Do you want to complete this ride?"
                        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                            let url: NSURL = URL(string: "TEL://802-375-5793")! as NSURL
                               UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                        }))
                        present(refreshAlert, animated: true, completion: nil)
                        kNotificationAction = ""
                        kConfirmationAction = ""
                        self.chooseRide_view.isHidden = true
                        self.ride_tableView.isHidden = true
                    }else{
                        self.ride_tableView.reloadData()
                    }
                }
                else  if kNotificationAction == "FEEDBACK" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "CANCELLED" {
                    kNotificationAction = ""
                    kConfirmationAction = ""
                    self.chooseRide_view.isHidden = true
                    self.ride_tableView.isHidden = true
                    self.chooseRideViewHeight_const.constant = 0
                }
                else  if kNotificationAction == "PENDING" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_RIDE" {
                    self.ride_tableView.reloadData()
                }
                else{
                    print("Nothing")
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                kRideId = (dict["ride_id"] as? String)!
                print(dictDataRideID)
            }
            if let dictDataDriverID = dict["driver_id"] as? String{
                print(dictDataDriverID)
                kDriverId = dictDataDriverID
            }
        }
    }
    @objc func loadForegroundList(_ notification: NSNotification){
        let notificationData = notification.userInfo
        if let dict = notificationData as? [String: Any] {
            print("userInfo: ", dict)
            if let dictData = dict["action"] as? String{
                print(dictData)
                kNotificationAction = dictData
                kConfirmationAction = dictData
                if let dictDataRideID = dict["ride_id"] as? String{
                    kRideId = (dict["ride_id"] as? String)!
                    getLastRideDataApi()
                    print(dictDataRideID)
                }
//                if kNotificationAction == "ACCEPTED"{
//                    self.ride_tableView.reloadData()
//                }
                
                if kNotificationAction == "ACCEPTED"{
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "COMPLETED"  {
                 //   self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "FEEDBACK" {
                  //  self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "CANCELLED" {
                }
                else  if kNotificationAction == "PENDING" {
                    self.ride_tableView.reloadData()
                }
                else  if kNotificationAction == "START_RIDE" {
                    self.ride_tableView.reloadData()
                }
                else{
                    print("Nothing")
                }
            }
            if let dictDataRideID = dict["ride_id"] as? String{
                print(dictDataRideID)
            }
            if let dictDataDriverID = dict["driver_id"] as? String{
                print(dictDataDriverID)
                kDriverId = dictDataDriverID
            }
           self.getLastRideDataApi()
        }
    }
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        self.getLastRideDataApi()
    }
    @IBAction func currentLocationClearBtnAction(_ sender: Any) {
        
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        
        self.pickUpAddress_lbl.text = "Enter Current Location"
        self.chooseRide_view.isHidden = true
        self.rideNow_btn.isHidden = true
        self.chooseRideViewHeight_const.constant = 0
        mapView.isMyLocationEnabled = false
        mapView.settings.myLocationButton = false
        mapView.clear()
        kNotificationAction = ""
        kConfirmationAction = ""
        locationPickUpEditStatus = false
        polyLine.map = nil
    }
    @IBAction func tapPickupLoction_btn(_ sender: Any) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.tap = 1
        self.autocompleteClicked()
    }
    @IBAction func tapDropLoaction_btn(_ sender: Any) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.tap = 0
        self.autocompleteClicked()
    }
    @IBAction func tapCancelDropAddress_btn(_ sender: Any) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.dropAddress_lbl.text = "Enter Drop Location"
        self.chooseRide_view.isHidden = true
        self.rideNow_btn.isHidden = true
        self.chooseRideViewHeight_const.constant = 230
        kNotificationAction = ""
        kConfirmationAction = ""
        polyLine.map = nil
        mapView.clear()
        locationDropUpEditStatus = false

    }
    @IBAction func tapRideNow_btn(_ sender: Any) {
//        if cardData.count == 0{
//            self.showAlert("GetDuma", message: "Please add card detail to start ride")
//
//        }else{
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
            if !(self.rideAmount == ""){
                self.rideNowApi()
            }
  //      }
       
    }

    func setNavButton(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        
       // self.navigationController?.view.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)

        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    
    func getDocumentsDirectory()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    func getAudioURL() -> URL {
        let filename = NSUUID().uuidString+".m4a"
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
    func startRecording(){
        do{
            let audioURL = self.getAudioURL()
            print("first \(audioURL)")
            audioRecorder = try AVAudioRecorder(url:self.getAudioURL(),settings:settings)
            audioRecorder.delegate = self
            audioRecorder.record(forDuration: 15)
        }catch{
            finishRecording(success: false)
        }
    }
    func finishRecording(success: Bool){
        audioRecorder.stop()
        if success{
            print("Recorded successfully!")
        }else{
            audioRecorder = nil
            print("Recording failed!")
        }
    }
}



extension HomeViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag{
            finishRecording(success:false)
            print("What is this url \(recorder.url)")
        }
        let refreshAlert = UIAlertController(title: Singleton.shared!.title , message: "Are you sure you want to save recording?", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action: UIAlertAction!) in
            self.audioRecorder = nil
          //  self.startRecording()
            let params = ["ride_id" : self.selectRideID ]
            self.requestForUpload(audioFilePath: recorder.url, parameters: params)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playBtnValue = "Play Recoring"
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
    func requestForUpload( audioFilePath: URL , parameters : [String: Any] ) {
        let url = URL(string: "https://www.getduma.com/audio_capture")!
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(audioFilePath, withName: "audio", fileName: "ajay", mimeType: "audio/m4a")
            for (key, value) in parameters {
                multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                print("KEY VALUE DATA===========\(key)"=="-----+++++----\(value)")
            }
        }, to: url, headers: headers)
        .responseJSON { response in
            print("URL AND HEADERS==========\(headers)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if (responseString["status"] as? Int ?? 0) == 1 {
                    self.showAlert("GetDuma", message: msg)
                }
                else{
                    self.showAlert("GetDuma", message: msg)
                }
                break;
            case .failure(let error):
                print(error)
                self.showAlert("GetDuma", message: "\(error.localizedDescription)")
                break
            }
        }
    }
}
