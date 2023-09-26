//
//  HomeExtension.swift
//  Ocory
//
//  Created by nile on 06/07/21.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire

//MARK:- Side Table View Datasource

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if kNotificationAction == "ACCEPTED"  || kConfirmationAction == "ACCEPTED" && kRideId != "" {
            self.chooseRide_view.isHidden = false
            
            if popupheight == "full"{
                self.chooseRideViewHeight_const.constant = 350
            }else{
                self.chooseRideViewHeight_const.constant = 200
            }
            
            chooseLbl.text = ""
            self.rideNow_btn.isHidden = true
            self.ride_tableView.isHidden = false
            return 1
        }
        else  if kNotificationAction == "NOT_CONFIRMED" || kConfirmationAction == "NOT_CONFIRMED" {
            self.chooseRideViewHeight_const.constant = 150
            self.chooseRide_view.isHidden = false
            self.rideNow_btn.isHidden = true
            chooseLbl.text = ""
            self.ride_tableView.isHidden = false
            return 1
        }
        else  if kNotificationAction == "COMPLETED" || kConfirmationAction == "COMPLETED" && kRideId != "" {
            
            self.chooseRideViewHeight_const.constant = 250
            self.chooseRide_view.isHidden = false
            chooseLbl.text = "Ride Completed!"
            self.rideNow_btn.isHidden = true
            self.ride_tableView.isScrollEnabled = false
            self.ride_tableView.isHidden = false
            return 1
        }
        else  if kNotificationAction == "FEEDBACK" || kConfirmationAction == "FEEDBACK" && kRideId != "" {
            self.chooseRideViewHeight_const.constant = 320
            self.chooseRide_view.isHidden = false
             chooseLbl.text = "Ride Completed!"
            self.rideNow_btn.isHidden = true
            self.ride_tableView.isScrollEnabled = false
            self.ride_tableView.isHidden = false
            return 1
        }
        else  if kNotificationAction == "CANCELLED" || kConfirmationAction == "CANCELLED" && kRideId != "" {
            if chooseVehicleList == .hide{
                self.chooseRide_view.isHidden = true
                self.rideNow_btn.isHidden = true
                self.ride_tableView.isHidden = true
                self.chooseRideViewHeight_const.constant = 0
                return 0
            }
            else{
                driverConfirmation = driverConfirmStatus.notConfirmed
                self.chooseRide_view.isHidden = false
                self.rideNow_btn.isHidden = true
                self.ride_tableView.isHidden = false
                self.chooseRideViewHeight_const.constant = 250
                return self.getAllVechileData.count
            }
        }
        else  if kNotificationAction == "PENDING" || kConfirmationAction == "PENDING" && kRideId != "" {
            self.chooseRideViewHeight_const.constant = 160
            self.chooseRide_view.isHidden = false
            self.rideNow_btn.isHidden = true
            chooseLbl.text = ""
            self.ride_tableView.isScrollEnabled = false
            self.ride_tableView.isHidden = false
            return 1
        }
        else  if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE" && kRideId != "" {
            self.chooseRide_view.isHidden = false
            self.rideNow_btn.isHidden = true
            self.chooseRideViewHeight_const.constant = 140
            self.ride_tableView.isHidden = false
            return 1
        }
        else{
            if chooseVehicleList == .hide{
                self.chooseRide_view.isHidden = true
                self.rideNow_btn.isHidden = true
                self.ride_tableView.isHidden = true
                self.chooseRideViewHeight_const.constant = 0
                return 0
            }
            else{
                driverConfirmation = driverConfirmStatus.notConfirmed
                self.chooseRide_view.isHidden = false
                self.rideNow_btn.isHidden = true
                self.ride_tableView.isHidden = false
                self.chooseRideViewHeight_const.constant = 250
                return self.getAllVechileData.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modalData = lastRideData
        
        if kNotificationAction == "ACCEPTED" || kConfirmationAction == "ACCEPTED" && kRideId != "" {
            getDriverLatLong(driverName: modalData?.driver_name ?? "", RideID: kRideId)
            
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "CallDriverCell", for: indexPath) as! CallDriverCell
            cell.callDriverBtn.addTarget(self, action: #selector(callDriverBtnAction), for: .touchUpInside)
            cell.mPopupMinMaxPopup.tag = indexPath.row
            cell.mPopupMinMaxPopup.addTarget(self, action: #selector(popupExtend(sender:)), for: .touchUpInside)
           /// cell.mPopupMinMaxPopup.addTarget(self, action: #selector(popupExtend), for: .touchUpInside)
            if popupheight == "full"{
                cell.mViewHeight.constant = 120
                cell.mPopupVieww.isHidden = false
            }else{
                cell.mViewHeight.constant = 0
                cell.mPopupVieww.isHidden = true
            }
            cell.cancelDriverBtn.addTarget(self, action: #selector(cancelDriverCallBtnAction), for: .touchUpInside)
           // cell.vehicleImageView.sd_setImage(with:URL(string: modalData?.user_profile_pic ?? "" ), placeholderImage: UIImage(named: "profile"), completed: nil)
          //  cell.vehicleImageView.image = UIImage(named: "carimg")
            
            
            cell.vehicleImageView.sd_setImage(with:URL(string: modalData?.vehicle_image ?? "" ), placeholderImage: UIImage(named: "carimg"), completed: nil)

            cell.driverImageView.sd_setImage(with:URL(string: modalData?.profile_pic ?? "" ), placeholderImage: UIImage(named: "profile"), completed: nil)
            cell.driverNameLabel.text = modalData?.driver_name ?? ""
           
            if timeD != ""{
                cell.timeLabel.text = timeD + " mins"
            }else{
                cell.timeLabel.text =  modalData?.total_time ?? ""
            }
           
         //   cell.distanceLabel.text  = "\(modalData?.total_distance ?? "")" + "les"
            cell.distanceLabel.text  = Dmiles + " miles"
            cell.driverRatingLabel.text =  modalData?.total_rating ?? ""
            cell.mUserNAme.text = kVehicle_no
            driverNumber =   modalData?.mobile ?? ""
            self.pickupBtn.isUserInteractionEnabled = false
            self.dropBtn.isUserInteractionEnabled = false
            self.pickupBtnCancel.isUserInteractionEnabled = false
            self.dropBtnCancel.isUserInteractionEnabled = false
               
            return cell
        }
        else  if kNotificationAction == "COMPLETED" || kConfirmationAction == "COMPLETED" && kRideId != "" {
            self.mapView.clear()
            //            if is_technical_issue == "Yes"{
            //                self.showAlert("GetDuma", message: "Sorry your last ride was completed due to technical issue")
            //                kNotificationAction = ""
            //                kConfirmationAction = ""
            //                self.chooseRide_view.isHidden = true
            //                self.ride_tableView.isHidden = true
            //            }else{
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "PaymentPopUpVCCell", for: indexPath) as! PaymentPopUpVCCell
           
            cell.PayNowBtn.tag = indexPath.row
            cell.PayNowBtn.addTarget(self, action: #selector(payNowBtnAction), for: .touchUpInside)
            cell.amountLabel.text  = "Amount to be Paid:" + "     $" + "\( modalData?.amount ?? "")"
            cell.mCancellationLBL.text = "Cancellation charge :       $" + self.cancellation_charge
            let amountt : Double = Double(modalData?.amount ?? "0.00")!
            if cancellation_charge != ""{
                let cancellation_charge  : Double = Double(cancellation_charge )!
                let totalamount = amountt + cancellation_charge
                cell.mTotalLBL.text = "Total amount:      $" + "\( totalamount )"
                self.totalamount = "\( totalamount )"
            }else{
                cell.mCancellationLBL.text = "Cancellation charge :       $0.00"
                self.totalamount = "\( modalData?.amount ?? "")"
              //  cell.mTotalLBL.text = "Total amount:      $" + "\( modalData?.amount ?? "")"
            }
            cell.mTotalLBL.text = "Total amount:      $" + "\( totalamount )"
            self.pickupBtn.isUserInteractionEnabled = false
            self.dropBtn.isUserInteractionEnabled = false
            self.pickupBtnCancel.isUserInteractionEnabled = false
            self.dropBtnCancel.isUserInteractionEnabled = false
            return cell
            //   }
        }
        else  if kNotificationAction == "NOT_CONFIRMED" || kConfirmationAction == "NOT_CONFIRMED" || kNotificationAction == "PENDING" || kConfirmationAction == "PENDING" {
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "DriverConfirmationCell", for: indexPath) as! DriverConfirmationCell
            cell.cancelBtn.addTarget(self, action: #selector(cancelDriverCallBtnAction), for: .touchUpInside)
            self.pickupBtn.isUserInteractionEnabled = false
            self.dropBtn.isUserInteractionEnabled = false
            self.pickupBtnCancel.isUserInteractionEnabled = false
            self.dropBtnCancel.isUserInteractionEnabled = false
            return cell
        }
        else  if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE" && kRideId != "" {
            getDriverLatLong(driverName: modalData?.driver_name ?? "", RideID: kRideId)
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "RideOnWayCell", for: indexPath) as! RideOnWayCell
            
            let lastRideid = modalData?.ride_id ?? ""
            
            if lastRideid == ""{
                cell.nameLabel.text = "Your ride is going with " + "\(kPaymentDriverName)"
                cell.amountLabel.text = "Amount to be paid $" + " " + "\(kPaymentRideAmount)"
            }
            else{
                cell.nameLabel.text = "Your ride is going with " + "\( modalData?.driver_name ?? "")"
                cell.amountLabel.text = "Amount to be paid $" + " " + "\( modalData?.amount ?? "")"
            }
            //  "$" + " " + "\(modalData?.amount  ?? "")"  + " " +
          //  cell.startRecordingBtn.addTarget(self, action: #selector(recordingBtnAction), for: .touchUpInside)
            return cell
        }
        else  if kNotificationAction == "FEEDBACK" || kConfirmationAction == "FEEDBACK"{
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "RideCompletedCell", for: indexPath) as! RideCompletedCell
            cell.rateView.delegate = self
            cell.rateView.maxCount = 5
            cell.rateView.fillImage = UIImage(named: "star")!
            cell.rateView.emptyImage = UIImage(named: "g-star")!
            cell.doneBtn.addTarget(self, action: #selector(doneRatedBtnAction), for: .touchUpInside)
            cell.mNoThanks.addTarget(self, action: #selector(NoThanksBtnAction), for: .touchUpInside)
            cell.nameLabel.text =  "How was your experience with" + " " + "\(modalData?.driver_name ?? "")"  + " driver"
            cell.commentTF.text =  ""
            cell.imageViw.sd_setImage(with:URL(string: modalData?.profile_pic ?? "" ), placeholderImage: UIImage(named: "profile"), completed: nil)
            self.pickupBtn.isUserInteractionEnabled = false
            self.dropBtn.isUserInteractionEnabled = false
            self.pickupBtnCancel.isUserInteractionEnabled = false
            self.dropBtnCancel.isUserInteractionEnabled = false
            return cell
        } 
        else{
            let cell = self.ride_tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
            //            let totalKmPrice  = self.getAllVechileData[indexPath.row].rate ?? ""
            //            let rideAmountPerKmInt = (totalKmPrice as NSString).integerValue
            //            let amount:Double =  Double(rideAmountPerKmInt)
            //            let nsValue: NSDecimalNumber = NSDecimalNumber(string: String(amount))
            //            let nsValue1: NSDecimalNumber = NSDecimalNumber(string: kDistanceInMiles)
            //            let nsValue3: NSDecimalNumber = nsValue.multiplying(by: nsValue1)
            //            print(nsValue3)
            //            kFinalAmountMile = "\(nsValue3)"
            //            kTotalRideAmountPerKmInt = "\(nsValue3)"
            cell.amount_lbl.text = "$ " + "\(self.getAllVechileData[indexPath.row].totalAmount ?? "")"
            //            let totalDistance: NSDecimalNumber = NSDecimalNumber(string: kDistanceInMiles)
            //            let amountPerVehicle: NSDecimalNumber = nsValue.multiplying(by: nsValue3)
            //            let finalAmountDistance  =  (totalDistance as Decimal)  * (amountPerVehicle as Decimal)
            //            print(finalAmountDistance)
            
            cell.vechileName_lbl.text = self.getAllVechileData[indexPath.row].title ?? ""
            cell.description_lbl.text = self.getAllVechileData[indexPath.row].shortDescription ?? ""
            cell.carImage.sd_setImage(with:URL(string: (self.getAllVechileData[indexPath.row].carPic ?? "") ), placeholderImage: UIImage(named: "profile"), completed: nil)
            return cell
        }
    }
    @objc func payNowBtnAction(sender:UIButton){
        
        if kPaymentRideAmount == "" && kPaymentRideId == ""{
            print("Last Ride data")
            let modalData = lastRideData
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.completedStatus = true
            vc.completedRideId = modalData?.ride_id ?? ""
            vc.completedAmount =  modalData?.amount ?? ""
            vc.vcCome = comeFrom.CompletedRequest
            vc.lastRideData =  lastRideData
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            print("New Ride data")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            vc.completedStatus = true
            vc.completedRideId = kPaymentRideId
            vc.completedAmount =  totalamount
            vc.completedFromPaynowStatus = true
            vc.vcCome = comeFrom.CompletedRequest
            vc.lastRideData =  lastRideData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func doneRatedBtnAction(){
        let modalData = lastRideData
        if kRating == ""{
            self.showAlert("GetDuma", message: "Please gives the rating star ")
        }
        else{
            let index = IndexPath(row: 0, section: 0)
            let cell: RideCompletedCell = self.ride_tableView.cellForRow(at: index) as! RideCompletedCell
            kCommentRating = cell.commentTF.text!
        //    if  getCellsDataOn(){
                self.postFeedBackApi(ride_id: modalData?.ride_id ?? "", rating: kRating, comment: kCommentRating, driverId: modalData?.driver_id ?? "")
                cell.commentTF.text = ""
//            }
//            else{
//                self.showAlert("GetDuma", message: "Please Enter Comment")
//            }
       }
    }
    @objc func NoThanksBtnAction() {
        let modalData = lastRideData
//        if kRating == ""{
//            self.showAlert("GetDuma", message: "Please gives the rating star ")
//        }
//        else{
            let index = IndexPath(row: 0, section: 0)
            let cell: RideCompletedCell = self.ride_tableView.cellForRow(at: index) as! RideCompletedCell
            kCommentRating = cell.commentTF.text!
        //    if  getCellsDataOn(){
                self.postFeedBackApi(ride_id: modalData?.ride_id ?? "", rating: kRating, comment: kCommentRating, driverId: modalData?.driver_id ?? "")
                cell.commentTF.text = ""
//            }
//            else{
//                self.showAlert("GetDuma", message: "Please Enter Comment")
//            }
  //     }
    }
   
    @objc func popupExtend(sender: UIButton){
        let buttonTag = sender.tag
        if sender.currentImage == UIImage(systemName: "minus.square.fill"){
            popupheight = "half"
            sender.setImage(UIImage(systemName: "arrow.up.left.and.arrow.down.right.circle.fill"), for: .normal)
        }else{
            popupheight = "full"
            sender.setImage(UIImage(systemName: "minus.square.fill"), for: .normal)
        }
        ride_tableView.reloadData()
        
    }
    @objc func callDriverBtnAction(){
       //kCustomerMobile.makeCall(phoneNumber: driverNumber)
        makecall()
    }
    
    func makecall(){
       // showIndicator()
        
        Indicator.shared.showProgressView(self.view)
        let cc = NSUSERDEFAULT.value(forKey: kownCcode)
        let mobile =  NSUSERDEFAULT.value(forKey: kownMobile)
        let requestParams: [String: Any] = ["Caller": mobile ?? "", "country_code" : cc ?? ""]
        let urlString = "\(baseURL)twilio/forward_call"
        let url = URL.init(string: urlString)
        print(url)
        print(requestParams)
        let AF = Session.default
       
        AF.request(urlString, method: .post, parameters: requestParams, encoding: URLEncoding.default)
            .response { response in
                Indicator.shared.hideProgressView()
                print("responseString: \(response)")
             //   self.hideIndicator()
               
                switch (response.result) {
                case .success(let response):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: response!, options: []) as? [String: Any] {
                            self.showAlert("GetDuma Driver", message: "Our team will call you shorty.")

                            // try to read out a string array
                            let status = json["message"] as? String

                           // print(status)
                           
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                      break
                    
                case .failure(let error):
                    print(error)
                    
                    self.showAlert("GetDuma", message: "\(error.localizedDescription)")
                    break
                }
            }
    }
    
    @objc func cancelDriverCallBtnAction(){
        self.cancelButtonAlert()
    }
//    @objc func cancelAutomatically(_ timer: Timer){
//        print("cancel Automatically")
//        var timerCountStatus = false
//        if kRideId != "" && timerCountStatus == true {
//            print("work 3 minutes more")
//            timerCountStatus = false
//        }
//        if kRideId != "" && timerCountStatus == false {
//            print("work 3 minutes")
//            timerCountStatus = true
//            if  kNotificationAction == "PENDING" && kConfirmationAction == "PENDING" {
//                self.cancelRideStatus(rideId: kRideId)
//            }
//        }
//    }
    @objc func recordingBtnAction(sender : UIButton){
        print("record btn")
        let modalData = lastRideData
        let modalRideId = modalData?.ride_id ?? ""
        selectRideID = modalRideId
        let tag:NSInteger = sender.tag;
        let indexPath = NSIndexPath(row: tag, section: 0)
        if let cell = ride_tableView.cellForRow(at: indexPath as IndexPath ) as? RideOnWayCell {
           // cell.startRecordingBtn.setTitle("Play Recoring", for: .normal)
            var playBtn = sender as! UIButton
            if toggleState == 1 {
                //  player.play()
                toggleState = 2
                playBtn.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.06666666667, blue: 0.05490196078, alpha: 1)
                playBtn.setTitle("Stop Record", for: .normal)
                showToast(message: "Recording Started")
                startRecording()
            } else {
                // player.pause()
                toggleState = 1
                playBtn.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.6235294118, blue: 0.1647058824, alpha: 1)
                playBtn.setTitle("Start Recording", for: .normal)
                showToast(message: "Recording Stopped")
                finishRecording(success: true)
            }
        }
        
    }
}
extension HomeViewController: RatingViewDelegate {
    func updateRatingFormatValue(_ value: Int) {
     //   print("Rating : = ", value)
        kRating = "\(value)"
    }
}


//MARK:- Side Table View Delegate
extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if kNotificationAction == "ACCEPTED"  || kConfirmationAction == "ACCEPTED" && kRideId != "" {
            
        }
        else  if kNotificationAction == "FEEDBACK" || kConfirmationAction == "FEEDBACK" {
            
        }
        else  if kNotificationAction == "NOT_CONFIRMED" || kConfirmationAction == "NOT_CONFIRMED" {
            
        }
        else  if kNotificationAction == "COMPLETED" || kConfirmationAction == "COMPLETED" && kRideId != "" {
            
        }
        //        else  if kNotificationAction == "CANCELLED" || kConfirmationAction == "CANCELLED" && kRideId != "" {
        //
        //        }
        else  if kNotificationAction == "PENDING" || kConfirmationAction == "PENDING" && kRideId != "" {
            
        }
        else  if kNotificationAction == "START_RIDE" || kConfirmationAction == "START_RIDE" && kRideId != "" {
            
        }
        else{
            
            //            let totalKmPrice  = self.getAllVechileData[indexPath.row].rate ?? ""
            //            let rideAmountPerKmInt = (totalKmPrice as NSString).integerValue
            //            let amount:Double =  Double(rideAmountPerKmInt)
            //            let nsValue: NSDecimalNumber = NSDecimalNumber(string: String(amount))
            //            let nsValue1: NSDecimalNumber = NSDecimalNumber(string: kDistanceInMiles)
            //            let nsValue3: NSDecimalNumber = nsValue.multiplying(by: nsValue1)
            //            print(nsValue3)
            self.rideAmount = self.getAllVechileData[indexPath.row].totalAmount ?? ""
            vehicleTypeId = self.getAllVechileData[indexPath.row].id ?? ""
            self.rideNow_btn.isHidden = false
            self.chooseRideViewHeight_const.constant = 270
        }
    }
    func getCellsDataOn() -> Bool {
        for section in 0 ..< self.ride_tableView.numberOfSections {
            for row in 0 ..< self.ride_tableView.numberOfRows(inSection: section) {
                let indexPath = NSIndexPath(row: row, section: section)
                let cell = self.ride_tableView.cellForRow(at: indexPath as IndexPath) as! RideCompletedCell
                if (cell.commentTF!.text! != "") {
                    //    print("Not Empty")
                    //Handle your function
                }else {
                    //     print("Empty")
                    return false
                }
            }
        }
        return true
    }
}
