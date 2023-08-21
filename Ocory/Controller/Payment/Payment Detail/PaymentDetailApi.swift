//
//  PaymentApi.swift
//  Ocory
//
//  Created by nile on 28/09/21.
//

import UIKit
import Alamofire
import Stripe
// MARK:--------API SECTION-----------

extension PaymentDetailVC {
    // MARK:- get stripe token
    func getStripeToken(cNumber:String,cExpiry:String,cCVC:String ,cName: String){
        print(cName)
        print(cNumber)
        print(cExpiry)
        print(cCVC)
        let finalcNumber = "\(cNumber)"
        let finalcCvv = cCVC as NSString
        let cardParams = STPCardParams()
        let expiryParameters = cExpiry.components(separatedBy: "/")
        let expiryMonth : Int = Int(expiryParameters.first ?? "0") ?? 0
        let expiryYear : Int = Int("20" + expiryParameters.last! ) ?? 0
        cardParams.expMonth = UInt(expiryMonth)
        cardParams.expYear = UInt(expiryYear)
        cardParams.number = finalcNumber
        cardParams.cvc = finalcCvv as String
        print(cardParams)
        STPAPIClient.shared.createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                self.showAlert("GetDuma", message: "\(String(describing: error?.localizedDescription ?? ""))")
                return
            }
            print("HERE IS THE TOKEN=======================\(String(describing: token))")
            if self.vcCome == .AddCard{
                if self.vcCard == .withoutCard{
                    self.saveCardApi(card_number: finalcNumber, expiry_month: "\(expiryMonth)", expiry_date: "\(expiryYear)", stripeToken: "\(token)", card_holder_name: cName)
                    self.goBackDelegate?.backButtonAction(selectedStatus: true)
                }
                else{
                    self.payApi(rideId: self.ridesStatusData?.rideID ?? "", amount: self.ridesStatusData?.amount ?? "", stripeToken: "\(token)", withoutCard: true)
                }
            }
            else{
                print("Completed List")
                if self.vcCard == .withoutCard{
                    self.saveCardApi(card_number: finalcNumber, expiry_month: "\(expiryMonth)", expiry_date: "\(expiryYear)", stripeToken: "\(token)", card_holder_name: cName)
                }
                else{
                    self.payApi(rideId: self.ridesStatusData?.rideID ?? "", amount: self.ridesStatusData?.amount ?? "", stripeToken: "\(token)", withoutCard: false)
                }
            }
        }
    }
    
    // MARK:- payment api
    func payApi(rideId:String,amount:String,stripeToken:String ,withoutCard : Bool){
        
        if withoutCard == true {
            let param = ["ride_id":rideId,"amount":amount ,"stripeToken" : stripeToken]
            Indicator.shared.showProgressView(self.view)
            self.conn.startConnectionWithPostType(getUrlString: "payment", params: param,authRequired: true) { (value) in
                print("payment Data===\(value)")
                Indicator.shared.hideProgressView()
                if self.conn.responseCode == 1{
                    print(value)
                    if (value["status"] as? Int ?? 0) == 1{
                        let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                        let msg = value["message"] as? String ?? ""
                        self.showAlertWithBackButton("GetDuma", message: "\(msg)")
                    }
                }
                else{
                    self.showAlert("GetDuma", message: "Payment not done")
                }
            }
        }
        else{
            print("Nothing")
        }
        
    }
    // MARK:- save card api 
    func saveCardApi(card_number:String,expiry_month:String,expiry_date:String,stripeToken:String,card_holder_name:String){
        let trimmedString = card_number.replacingOccurrences(of: " ", with: "")
        let param = ["card_number":trimmedString,"expiry_month":expiry_month ,"expiry_date":expiry_date,"card_holder_name":card_holder_name ,"stripeToken" : stripeToken,"billing_address" : billingAddress.text ?? ""]
        print(param)
        Indicator.shared.showProgressView(self.view)
        
        print(param)
//        let urlString = "https://www.niletechinnovations.com/projects/ocory/add_customer"
//        let url = URL.init(string: urlString)
//        var headers: HTTPHeaders = [:]
//        headers = ["Authorization" : "Bearer " + (UserDefaults.standard.value(forKey: "token") as? String ?? "")
//        ]
//        print(headers)
//
//        AF.request(urlString, method: .post, parameters: param, encoding: URLEncoding.default, headers: headers)
//                .responseString { response in
//                    print("responseString: \(response)")
//                    Indicator.shared.hideProgressView()
//                    switch (response.result) {
//                    case .success(let JSON):
//                        print("JSON: \(JSON)")
//                        break;
//                    case .failure(let error):
//                        print(error)
//                        self.showAlert("Ocory", message: "\(error.localizedDescription)")
//                        break
//                    }
//                }
        self.conn.startConnectionWithPostType(getUrlString: "add_customer", params: param,authRequired: true) { (value) in
            print("Add New Card Data===\(value)")
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = value["message"] as? String ?? ""
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    self.showAlertWithBackButton("GetDuma", message: "\(msg)")
                    
                    self.goBackDelegate?.backButtonAction(selectedStatus: true)
                }
                else{
                    self.showAlert("GetDuma", message: "\(msg)")
                }
            }
            else{
                self.showAlert("GetDuma", message: "Your card details are incorrect")
            }
        }
    }
}
