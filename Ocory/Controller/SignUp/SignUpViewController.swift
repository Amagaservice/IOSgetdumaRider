//
//  SignUpViewController.swift
//  Ocory
//
//  Created by Arun Singh on 2/11/21.
//

import UIKit
import Alamofire
import GoogleMaps
import GooglePlaces

class SignUpViewController: UIViewController {

    @IBOutlet var mCountryTF: UITextField!
    //MARK:- OUTLETS
    @IBOutlet weak var mDrivingLicenceTXTFLD: UITextField!
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var name_txtField: UITextField!
    @IBOutlet weak var emailAddress_txtField: UITextField!
    @IBOutlet weak var password_txtField: UITextField!
    @IBOutlet weak var confirmPass_txtField: UITextField!
    @IBOutlet weak var mobileNo_txtField: UITextField!
    @IBOutlet weak var SSNo_txtField: UITextField!
    @IBOutlet weak var dOBTF: NoPasteTextField!
    @IBOutlet weak var homeAddress: UITextView!
    @IBOutlet weak var signUp_btn: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var identificationProofImageView: UIImageView!
    
    //MARK:- Variables
    
    let conn = webservices()
    var profileImg : UIImage?
    var identificationProofImg : UIImage?
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    var document_Data = [RidesData]()
    var pickerView1 = UIPickerView()
    var selectedservice: String?
    var DOBdatePicker = UIDatePicker()
    
    var selectedID = String()
    
    var counPicker = CountryPicker()

    enum imagePic {
        case imageProfile
        case imageIdentificationProof
    }
    var imagePickStatus =  imagePic.imageProfile
    lazy var imagePicker :ImagePickerViewControler  = {
        return ImagePickerViewControler()
    }()
   // var toolBar = UIToolbar()
   // let datePicker = UIDatePicker()

    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        getdataApi()
        
        mCountryTF.inputView = counPicker
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        homeAddress.delegate = self
        
        pickerView1.delegate = self
        mDrivingLicenceTXTFLD.delegate = self
        mDrivingLicenceTXTFLD.inputView = pickerView1
        homeAddress.text = "Home Address"
        homeAddress.textColor = UIColor.lightGray
        homeAddress.delegate = self
        SSNo_txtField.delegate = self
        name_txtField.delegate = self
        name_txtField.setLeftPaddingPoints(20)
        emailAddress_txtField.setLeftPaddingPoints(20)
        password_txtField.setLeftPaddingPoints(20)
        confirmPass_txtField.setLeftPaddingPoints(20)
        mobileNo_txtField.setLeftPaddingPoints(50)
        
        SSNo_txtField.setLeftPaddingPoints(20)
        dOBTF.setLeftPaddingPoints(20)
        
        mDrivingLicenceTXTFLD.setLeftPaddingPoints(20)
        mExpirydateTF.setLeftPaddingPoints(20)
        mIssueDateTF.setLeftPaddingPoints(20)
        
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        dOBTF.delegate = self
        self.signUp_btn.layer.cornerRadius = 5
//        self.dOBTF.datePicker(target: self,
//                                          doneAction: #selector(doneAction),
//                                          cancelAction: #selector(cancelAction),
//                                          datePickerMode: .date)
//
    }
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
            DOBdatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        DOBdatePicker.datePickerMode = .date
        DOBdatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        DOBdatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -83, to: Date())

        dOBTF.inputView = DOBdatePicker
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mIssueDateTF.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        mExpirydateTF.inputView = datePicker2
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- User Defined Func
    @IBAction func dateOfBirthBtn(_ sender: Any) {
        print("press")
    }
    
      @objc
      func cancelAction() {
          self.dOBTF.resignFirstResponder()
      }

 //     @objc
//      func doneAction() {
//          if let datePickerView = self.dOBTF.inputView as? UIDatePicker {
//              datePickerView.datePickerMode = .date
//              datePickerView.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
//              if #available(iOS 13.4, *) {
//                  datePickerView.preferredDatePickerStyle = .wheels
//              } else {
//                  // Fallback on earlier versions
//              }
//              let dateFormatter = DateFormatter()
//              dateFormatter.dateFormat = "yyyy-MM-dd"
//              let dateString = dateFormatter.string(from: datePickerView.date)
//              self.dOBTF.text = dateString
//
//              print(datePickerView.date)
//              print(dateString)
//
//              self.dOBTF.resignFirstResponder()
//          }
//      }
    
    //MARK:- Button Action
    @IBAction func back_btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tapEyePassword_btn(_ sender: UIButton) {
        password_txtField.isSecureTextEntry.toggle()
         if password_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         }else{
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    
    @IBAction func tapEyeConfirmPassword_btn(_ sender: UIButton) {
        confirmPass_txtField.isSecureTextEntry.toggle()
         if confirmPass_txtField.isSecureTextEntry {
             if let image = UIImage(systemName: "eye.slash.fill") {
                 sender.setImage(image, for: .normal)
             }
         } else {
             if let image = UIImage(systemName: "eye.fill") {
                 sender.setImage(image, for: .normal)
             }
         }
    }
    @IBAction func profilePicBtnAction(){
        imagePickStatus = .imageProfile
//        self.imagePicker.imagePickerDelegete = self
//        self.imagePicker.showImagePicker(viewController: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func identificationProofBtnAction(){
        imagePickStatus = .imageIdentificationProof
//        self.imagePicker.imagePickerDelegete = self
//        self.imagePicker.showImagePicker(viewController: self)
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //MARK:- open camera
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    //MARK:- open gallery
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func tapSignUp_btn(_ sender: Any) {
        
        if self.name_txtField.text == ""{
            self.showAlert("GetDuma", message: "Please enter name")
        }else if self.emailAddress_txtField.text == ""{
            self.showAlert("GetDuma", message: "Please enter email address")
        }else if !(Validation().isValidEmail(self.emailAddress_txtField.text!)){
            self.showAlert("GetDuma", message: "Please enter valid email address")
        }else if self.password_txtField.text == "" {
            self.showAlert("GetDuma", message: "Please enter password")
        }else if (self.password_txtField.text?.count ?? 0) < 6{
            self.showAlert("GetDuma", message: "Please enter six charcter password")
        }else if self.confirmPass_txtField.text == "" {
            self.showAlert("GetDuma", message: "Please enter confirm password")
        }else if !(self.password_txtField.text == self.confirmPass_txtField.text){
            self.showAlert("GetDuma", message: "Password and Confirm Password does not match")
        }else if self.mCountryTF.text == ""{
            self.showAlert("GetDuma", message: "Please select country code")
        }else if self.mobileNo_txtField.text == ""{
            self.showAlert("GetDuma", message: "Please enter mobile number")
        }else if self.dOBTF.text == ""{
            self.showAlert("GetDuma", message: "Please enter DOB")
        }else if self.homeAddress.text == ""{
            self.showAlert("GetDuma", message: "Please enter home address")
        }else if self.profileImg == nil{
            self.showAlert("GetDuma", message: "Please select profile pic")
        }else if self.mDrivingLicenceTXTFLD.text == ""{
            self.showAlert("GetDuma", message: "Please select identity")
        }else if self.mIssueDateTF.text == ""{
            self.showAlert("GetDuma", message: "Please enter issue date")
        }else if self.mExpirydateTF.text == ""{
            self.showAlert("GetDuma", message: "Please enter expiry date")
        }else if self.identificationProofImg == nil{
            self.showAlert("GetDuma", message: "Please select identification proof pic")
        }else{
            self.uploadPhotoGallaryNewSignup(media: self.profileImg!, mediaLicense: self.identificationProofImg!)
        }
    }
    @IBAction func tapSignIn_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
   // MARK:- getdocumentidentity data
    
    func getdataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_documentidentity_get",authRequired: false) { (value) in
            print("Profile Data Api  \(value)")
            Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
            //  let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.document_Data = try newJSONDecoder().decode(rides.self, from: jsonData)
                    print(self.document_Data)
                   // self.pendingReq_tableView.reloadData()
                }catch{
                    print(error.localizedDescription)
                }
            }else{
                guard let stat = value["Error"] as? String, stat == "ok" else {
                    //self.showAlert("Ocory", message: "\(String(describing: stat))")
                    return
                }
            }
        }
    }
    
}
extension SignUpViewController: CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(String(describing: place.name))")
        print("Place placeID: \(String(describing: place.placeID))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place address: \(String(describing: place.addressComponents))")
        
        homeAddress.textColor = UIColor.black
        homeAddress.text = place.formattedAddress
        dismiss(animated: true, completion: nil)
    }
}
extension SignUpViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        if textView == homeAddress{
//            let autocompleteController = GMSAutocompleteViewController()
//            autocompleteController.delegate = self
//            present(autocompleteController, animated: true, completion: nil)
//            return
//        }
        
        if homeAddress.textColor == UIColor.lightGray {
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
         
            homeAddress.text = ""
            homeAddress.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if homeAddress.text.isEmpty {
            homeAddress.text = "Home Address"
            homeAddress.textColor = UIColor.lightGray
        }
    }
}
//MARK:- picker

extension SignUpViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return document_Data.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return document_Data[row].document_name! // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedservice = document_Data[row].document_name!
        selectedID = document_Data[row].id!
       // mDrivingLicenceTXTFLD.text = document_Data[row].document_name!
    //    IDselected = searchModel[row].id!
    }
}


//MARK:- Web Api
extension SignUpViewController{
    // MARK:- signup api 
//    func registerApi(){
//
//        let param = ["email":self.emailAddress_txtField.text!,"name":self.name_txtField.text!,"mobile":self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"India","city":"Noida","state":"U.P","latitude":0.0,"longitude":0.0 , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? ""] as [String : Any]
//        Indicator.shared.showProgressView(self.view)
//        self.conn.startConnectionWithPostType(getUrlString: "register", params: param) { (value) in
//
//            Indicator.shared.hideProgressView()
//            if self.conn.responseCode == 1{
//
//                print(value)
//                let msg = (value["message"] as? String ?? "")
//
//                if ((value["status"] as? Int ?? 0) == 1){
//
//                    let token = (value["token"] as? String ?? "")
//                    let data = (value["data"] as? [String:Any] ?? [:])
//                    let card1 = (data["is_card"] as? Int ?? 0)
//                    let addCard = (data["add_card"] as? Int ?? 0)
//
//                    print(data)
//                    UserDefaults.standard.setValue(token, forKey: "token")
//                    self.showAlertWithAction(Title: "GetDuma", Message: msg, ButtonTitle: "OK") {
//
////                        if addCard == 1 &&  card1 == 0{
////                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
////                            self.navigationController?.pushViewController(vc, animated: true)
////                        }
////                        else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
////
//  //                      }
//                    }
//                }else{
//
//                    self.showAlert("GetDuma", message: msg)
//                }
//
//            }
//        }
//    }
    
    func uploadPhotoGallaryNewSignup(media: UIImage ,mediaLicense: UIImage ){
        
        let params = ["email":self.emailAddress_txtField.text!, "name":self.name_txtField.text!, "country_code": mCountryTF.text ?? "" , "mobile": self.mobileNo_txtField.text!,"password":self.password_txtField.text!,"utype":1,"country":"","city":"","state":"","latitude":kCurrentLocaLat,"longitude":kCurrentLocaLong , "gcm_token" :  NSUSERDEFAULT.value(forKey: kFcmToken) as? String ?? "" , "dob" : dOBTF.text ?? "" , "home_address" : homeAddress.text ?? "" ,"ssn" :SSNo_txtField.text ?? "" ,"identification_document_id" : selectedID,"identification_issue_date" : mIssueDateTF.text ?? "","identification_expiry_date": mExpirydateTF.text ?? ""] as [String : Any]
        print(params)
        let imageData = media.jpegData(compressionQuality: 0.25)
        let imageDataLicence = mediaLicense.jpegData(compressionQuality: 0.25)
        print("image data\(String(describing: imageData))")
        let url = URL(string: "\(baseURL)register")!
//        let headers: HTTPHeaders = [
//           // "Content-type": "multipart/form-data",
//            "Accept": "application/json",
//            "authorization": "Bearer \(UserDefaults.standard.value(forKey: "token") as? String ?? "")"
//        ]
        Indicator.shared.showProgressView(self.view)
        AF.upload(multipartFormData: { multipartFormData in
            if imageData != nil{
                multipartFormData.append(imageData!,
                                         withName: "avatar" , fileName: "avatar.jpg", mimeType: "image/jpeg"
                )
            }
            if imageDataLicence != nil{
                multipartFormData.append(imageDataLicence!,
                                         withName: "verification_id" , fileName: "verification_id.jpg", mimeType: "image/jpeg"
                )
            }
            for p in params {
                multipartFormData.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
                print("KEY VALUE DATA===========\(p.key)"=="-----+++++----\(p.value)")
            }
        }, to: url)
        .responseJSON { response in
           print("URL AND HEADERS==========\(url)")
            print(response)
            Indicator.shared.hideProgressView()
            switch (response.result) {
            case .success(let JSON):
                print("JSON: \(JSON)")
                let responseString = JSON as! NSDictionary
                print(responseString)
                let msg = responseString["message"] as? String ?? ""
                if ((responseString["status"] as? Int ?? 0) == 1){
                    
                    let token = (responseString["token"] as? String ?? "")
                    let data = (responseString["data"] as? [String:Any] ?? [:])
                    let card1 = (data["is_card"] as? Int ?? 0)
                    let addCard = (data["add_card"] as? Int ?? 0)

                    print(data)
                    UserDefaults.standard.setValue(token, forKey: "token")
                    self.showAlertWithAction(Title: "GetDuma", Message: msg, ButtonTitle: "OK") {
                        self.navigationController?.popViewController(animated: false)
//                        if addCard == 1 &&  card1 == 1{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        }
//                        else{
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignupPaymentVC") as! SignupPaymentVC
//                            self.navigationController?.pushViewController(vc, animated: true)
//
//                        }
                    }
                }else{
                    
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

extension SignUpViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
           
            if imagePickStatus == .imageProfile {
                profileImageView.image = pickedImage
                self.profileImg = pickedImage
            }
            if imagePickStatus == .imageIdentificationProof{
                identificationProofImageView.image = pickedImage
                self.identificationProofImg = pickedImage
                
            }
          
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
extension UITextField {
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
extension SignUpViewController: UITextFieldDelegate{
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == name_txtField{
            var ACCEPTABLE_CHARACTER = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            if range.location == 0 && string == " " { // prevent space on first character
                return false
            }
            if textField.text?.last == " " && string == " " { // allowed only single space
                return false
            }
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTER).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
            return true
//        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == mIssueDateTF{
            showDatePicker()
           
        }else if textField == mExpirydateTF{
            showDatePicker()
          //  mEndDateTXTFLD.text = ""
        }else if textField == dOBTF{
            showDatePicker()
          
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField == mIssueDateTF {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mIssueDateTF.text = formatter.string(from: selectedDate)
        }else if textField == mExpirydateTF {
            let selectedDate = datePicker2.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.mExpirydateTF.text = formatter.string(from: selectedDate)
        }else if textField == dOBTF {
            let selectedDate = DOBdatePicker.date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.dOBTF.text = formatter.string(from: selectedDate)
        }else if textField == mDrivingLicenceTXTFLD{
            if selectedservice == nil{
                if document_Data.count != 0{
                    selectedservice = document_Data[0].document_name!
                  //  IDselected = searchModel.first?.id! as! String
                    selectedID = document_Data[0].id!
                    mDrivingLicenceTXTFLD.text = selectedservice
                }
            }else{
                mDrivingLicenceTXTFLD.text = selectedservice
            }
        }
    }
}
extension SignUpViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryTF.text = phoneCode
    }
}
