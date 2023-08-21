//
//  SignupPaymentVC.swift
//  Ocory
//
//  Created by nile on 10/06/22.
//

import UIKit
import Stripe
import Alamofire
class SignupPaymentVC: UIViewController {
    @IBOutlet weak var cardNameTf: UITextField!
    @IBOutlet weak var cardNumberTf: UITextField!
    @IBOutlet weak var cardExpiryTf: UITextField!
    @IBOutlet weak var cardCvvTf: UITextField!
    @IBOutlet weak var billingAddress: UITextView!

    var selectedCardStatus : Bool?
    var maxLenCardNumber:Int = 16;
    var maxLenCardCVV:Int = 3;
    var ridesStatusData : RidesData?
    let conn = webservices()
    var vcCome = comeFrom.AddCard
    var vcCard = paymentType.withoutCard
    var cardData = [cardDataModal]()
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?

    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTf.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.setNavButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Card Detail"
        
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
        UserDefaults.standard.synchronize()
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.setViewControllers([loginVc], animated: true)
    }
    
    @IBAction func payBtn(_ sender: Any) {
        guard let cardName = cardNameTf.text, cardName != "" else {
            self.showAlert("GetDuma", message: "Please enter Card Name!")
            return
        }
        guard let cardNumber = cardNumberTf.text, cardNumber != "" else {
            self.showAlert("GetDuma", message: "Please enter card Number!")
            return
        }
        guard let cardExpiry = cardExpiryTf.text, cardExpiry != "" else {
            self.showAlert("GetDuma", message: "Please enter expiry date")
            return
        }
        guard let cardCvv = cardCvvTf.text, cardCvv != "" else {
            self.showAlert("GetDuma", message: "Please enter card CVV" )
            return
        }
//        if cardCvvTf.text!.count < 3  {
//            self.showAlert("GetDuma", message: "Please enter correct Cvv" )
//            return
//        }
        guard let billingAdd = billingAddress.text, billingAdd != "" else {
            self.showAlert("GetDuma", message: "Please enter billing Address" )
            return
        }
        if cardNameTf.text != "" && cardNumberTf.text != "" && cardExpiryTf.text != "" && cardCvvTf.text != ""{
            
            if vcCome == .CompletedRequest || vcCome == .AddCard  {
                if vcCard == .withoutCard{
                    //saveCardApi(card_number: cardNumber, expiry_month: <#T##String#>, expiry_date: <#T##String#>, stripeToken: <#T##String#>, card_holder_name: <#T##String#>)
                    getStripeToken(cNumber: cardNumber, cExpiry: cardExpiry, cCVC: cardCvv, cName: cardName)
               }
                else{
                    
                }
            }
        }
    }
}
// MARK:--------TEXTFIELD DELEGATE-----------

extension SignupPaymentVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == cardExpiryTf){
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }
            let updatedText = oldText.replacingCharacters(in: r, with: string)
            
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" {
                    return false
                }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { //Prevent user to not enter month more than 12
                    textField.text = "\(updatedText)/" //This will add "/" when user enters 2nd digit of month
                }
                return false
            } else if updatedText.count == 5 {
                self.expDateValidation(dateStr: updatedText)
            } else if updatedText.count > 5 {
                return false
            }
            
        }
        
        
        if(textField == cardNumberTf){
            let currentText = textField.text! + string
          //  return currentText.count <= maxLenCardNumber
            previousTextFieldContent = textField.text;
            previousSelection = textField.selectedTextRange;
        }
        if(textField == cardCvvTf){
            let currentText = textField.text! + string
            return currentText.count <= maxLenCardCVV
        }
        
        return true
    }
    
    
    func expDateValidation(dateStr:String) {
        
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateStr.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateStr.prefix(2)) ?? 0 // get first two digit from entered string as month
        print(dateStr) // This is MM/YY Entered by user
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                print("Entered Date Is Right")
            } else {
                print("Entered Date Is Wrong")
                self.showAlert("GetDuma", message: "Entered Year Is Wrong")
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    print("Entered Date Is Right")
                } else {
                    print("Entered Date Is Wrong")
                    self.showAlert("GetDuma", message: "Entered Furure Year")
                }
            } else {
                print("Entered Date Is Wrong")
            }
        } else {
            print("Entered Date Is Wrong")
        }
        
    }
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
       
        
        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    // MARK:- remove non digits
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        return digitsOnlyString
    }
    // MARK:- insert Spaces Every Four Digits Into String
    func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append(contentsOf: " ")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func setNavButton(){
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
}



// MARK:--------API SECTION-----------

extension SignupPaymentVC {
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
                  //  self.goBackDelegate?.backButtonAction(selectedStatus: true)
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
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
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
        let param = ["card_number":trimmedString,"expiry_month":expiry_month ,"expiry_date":expiry_date,"card_holder_name":card_holder_name ,"stripeToken" : stripeToken ,"billing_address" : billingAddress.text ?? ""]
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
        //
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
        self.conn.startConnectionWithPostType(getUrlString: "add_customer", params: param,authRequired: true) { [self] (value) in
            print("Add New Card Data===\(value)")
            Indicator.shared.hideProgressView()
            if self.conn.responseCode == 1{
                print(value)
                let msg = value["message"] as? String ?? ""
                if (value["status"] as? Int ?? 0) == 1{
                    let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                    self.savedCardApi()
                    //                    do{
                    //                        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    //                        self.cardData = try newJSONDecoder().decode(userCardData.self, from: jsonData)
                    //                        setdefaultCardApi(card_id: cardData[0].id!, is_default: "1")
                    //                      //  self.payment_tableView.reloadData()
                    //                   // self.showAlertWithBackButton("GetDuma", message: "\(msg)")
                    //                   // self.goBackDelegate?.backButtonAction(selectedStatus: true)
                    //
                    //                    }catch{
                    //                        print(error.localizedDescription)
                    //                    }
                    //
                    //
//                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                                        self.navigationController?.pushViewController(vc, animated: true)
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
    // MARK:- save card api
        func savedCardApi(){
            Indicator.shared.showProgressView(self.view)
            self.conn.startConnectionWithGetTypeWithParam(getUrlString: "card_list",authRequired: true) { (value) in
                Indicator.shared.hideProgressView()
                if self.conn.responseCode == 1{
                    print(value)
                    if (value["status"] as? Int ?? 0) == 1{
                        let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                        do{
                            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                            self.cardData = try newJSONDecoder().decode(userCardData.self, from: jsonData)
                            self.setdefaultCardApi(card_id: self.cardData[0].id!, is_default: "1")
                           // self.savedCardApi()
                          //  self.payment_tableView.reloadData()
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }
                else{
                    self.showAlert("GetDuma", message: "Could not get response")
                }
            }
        }
    // MARK:- make card default for payment
        func setdefaultCardApi(card_id:String,is_default:String){
            let param = ["card_id":card_id,"is_default":is_default]
            Indicator.shared.showProgressView(self.view)
            self.conn.startConnectionWithPostType(getUrlString: "make_default", params: param,authRequired: true) { (Value) in
                Indicator.shared.hideProgressView()
                if self.conn.responseCode == 1{
                    let msg = (Value["message"] as? String ?? "")
                    if (Value["status"] as? Int ?? 0) == 1{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        print(Value)
                       // self.savedCardApi()
                    }else{
                        self.showAlert("GetDuma", message: msg)
                    }
                }
            }
        }
        
    }

