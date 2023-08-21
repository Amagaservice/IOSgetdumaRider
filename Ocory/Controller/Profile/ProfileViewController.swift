//
//  ProfileViewController.swift
//  Ocory
//
//  Created by Arun Singh on 23/02/21.
//

import UIKit
import TOCropViewController
import SDWebImage
import Alamofire

class ProfileViewController: UIViewController {
    //MARK:- OUTLETS
    @IBOutlet var mCountryTF: UITextField!
    @IBOutlet weak var mExpirydateTF: UITextField!
    @IBOutlet weak var mIssueDateTF: UITextField!
    @IBOutlet weak var mDocTF: SetTextField!
    @IBOutlet weak var userImg: SetImageView!
    @IBOutlet weak var name_txtField: SetTextField!
    @IBOutlet weak var email_txtField: SetTextField!
    @IBOutlet weak var mobile_txtField: SetTextField!
    @IBOutlet weak var mImgLBL: UILabel!
    @IBOutlet weak var mImg: SetImageView!
    var datePicker = UIDatePicker()
    var datePicker2 = UIDatePicker()
    //MARK:- Variables
    var imageData : Data?
    var imageName : String?
    lazy var imagePicker :ImagePickerViewControler  = {
        
        return ImagePickerViewControler()
        
    }()
    let conn = webservices()
    var profileDetails : ProfileData?
    var img = UIImage()
    var docimg = UIImage()
    var acceptedReqData = [RidesData]()
    var selectedservice: String?
    var pickerView1 = UIPickerView()
    var selectedID = String()
  //  var imagePickStatus =  imagePic.imageProfile
   var imagePick = ""
    var counPicker = CountryPicker()

    //MARK:- Default Func
    override func viewDidLoad() {
        super.viewDidLoad()
        mExpirydateTF.setLeftPaddingPoints(20)
        mIssueDateTF.setLeftPaddingPoints(20)
        
        name_txtField.delegate = self
        mCountryTF.inputView = counPicker
        self.counPicker.countryPickerDelegate = self
        self.counPicker.showPhoneNumbers = true
        mobile_txtField.setLeftPaddingPoints(50)
        mIssueDateTF.delegate = self
        mExpirydateTF.delegate = self
        mDocTF.delegate = self
        mDocTF.inputView = pickerView1
        pickerView1.delegate = self
        mCountryTF.delegate = self
        kProfileInputStatus = false
        name_txtField.delegate = self
        mobile_txtField.delegate = self
        mDocTF.layer.borderWidth = 1
        mDocTF.layer.borderColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.setNavButton()
        self.setData()
        userImg.isUserInteractionEnabled = true
        name_txtField.isUserInteractionEnabled = true
        email_txtField.isUserInteractionEnabled = true
        mobile_txtField.isUserInteractionEnabled = true
    
        getdataApi()
    }
    //MARK:- Date Picker
    func showDatePicker(){
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker2.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
      
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        mIssueDateTF.inputView = datePicker
        
        datePicker2.datePickerMode = .date
        datePicker2.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        mExpirydateTF.inputView = datePicker2
        
    }
    @IBAction func editBtnAction( _ sender : UIButton){
        userImg.isUserInteractionEnabled = true
        name_txtField.isUserInteractionEnabled = true
        email_txtField.isUserInteractionEnabled = true
        mobile_txtField.isUserInteractionEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Profile"
        self.getProfileDataApi()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    //MARK:- User Defined Func
    func setNavButton(){
        let logoBtn = UIButton(type: .custom)
        logoBtn.setImage(UIImage(named: "shape_28"), for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7411764706, blue: 0.09803921569, alpha: 1)
        logoBtn.addTarget(self, action: #selector(tapNavButton), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: logoBtn)
        self.navigationItem.leftBarButtonItem = barButton
    }
    @objc func tapNavButton(){
        let presentedVC = self.storyboard!.instantiateViewController(withIdentifier: "SideMenuViewController")
        let nvc = UINavigationController(rootViewController: presentedVC)
        present(nvc, animated: false, pushing: true, completion: nil)
    }
    //MARK:- set data from model
    func setData(){
        self.userImg.sd_setImage(with:URL(string: (self.profileDetails?.profilePic) ?? ""), placeholderImage: nil, completed: nil)
        self.name_txtField.text = self.profileDetails?.name
        self.email_txtField.text = self.profileDetails?.email
        self.mCountryTF.text = self.profileDetails?.country_code

        if profileDetails?.identification_document_id != nil{
         //   var se
            selectedID =  (self.profileDetails?.identification_document_id)!
            for i in 0..<acceptedReqData.count{
                if acceptedReqData[i].id == selectedID{
                    mDocTF.text = acceptedReqData[i].document_name!
                    break
                }
            }
         //   mDocTF.text = acceptedReqData[Int(selectedID ?? "")!].document_name!
            mImg.sd_setImage(with:URL(string: (self.profileDetails?.verification_id) ?? ""), placeholderImage: nil, completed: nil)
        }
        if profileDetails?.identification_issue_date != nil{
            mIssueDateTF.text = profileDetails?.identification_issue_date
        }
        if profileDetails?.identification_expiry_date != nil{
            mExpirydateTF.text = profileDetails?.identification_expiry_date
        }
        if profileDetails?.mobile != nil{
            self.mobile_txtField.text = self.profileDetails?.mobile ?? ""
        }
        kProfileEditMobile = self.profileDetails?.mobile ?? ""
        if kProfileInputStatus == true{
            self.mobile_txtField.text = kProfileEditMobile
        }
        else{
            self.mobile_txtField.text = self.profileDetails?.mobile ?? ""
        }
    }
    @IBAction func updateBtnAction( _ sender : UIButton){
        print(kProfileInputStatus)
    //    if kProfileInputStatus == true{
            let index = sender.tag
            let param = ["name":name_txtField.text ?? "","country_code": mCountryTF.text ?? "" , "mobile": mobile_txtField.text ?? "", "identification_document_id" : selectedID, "identification_issue_date" : mIssueDateTF.text ?? "","identification_expiry_date": mExpirydateTF.text ?? "","verification_id" : docimg] as [String : Any]
            print(param)
            if kProfileEditMobile.count >= 10 {
                if kProfileDOCImageUpdateStatus == true {
                    self.updateProfileApi(imageOrVideo: self.docimg, params: param)
                }else{
                    self.updateProfileApi(imageOrVideo: nil, params: param)
                }
               // self.updateProfileApi(imageOrVideo: nil, params: param)
            }
//            else{
//                self.showAlert("GetDuma", message: "phone number should be minimum 10 digit")
//            }
    //    }
        if kProfileImageUpdateStatus == true {
       // self.uploadProfilePhotoAPI(image: self.img, params: [:])
            self.uploadPhotoGallaryNew(media: self.img, params: [:])
         //   self.uploadPhotoGallaryNewSignup(mediaLicense: self.docimg)

        }
        if kProfileDOCImageUpdateStatus == true {
       // self.uploadProfilePhotoAPI(image: self.img, params: [:])
          //  self.uploadPhotoGallaryNew(media: self.img, params: [:])
        //    self.updateProfileApi(imageOrVideo: docimg, params: param)
         //   self.uploadPhotoGallaryNewSignup(imageData: self.docimg, params: [:])

        }
        
    }
    //MARK:- Button Action
    @IBAction func tapChangePass_btn(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        vc.modalPresentationStyle = .overFullScreen
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tapSelectImage_btn(_ sender: Any) {
       // self.imagePicker.imagePickerDelegete = self
        //self.imagePicker.showImagePicker(viewController: self)
        imagePick = "profile"
        
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
    //MARK:- opend camera
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
    @IBAction func mUploadImageBTN(_ sender: Any) {
        imagePick = "doc"
     //   imagePickStatus = .imageProfile
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
    //MARK:- Get Documentidentity
    func getdataApi() {
        Indicator.shared.showProgressView(self.view)
        self.conn.startConnectionWithGetTypeWithParam(getUrlString: "get_documentidentity_get",authRequired: true) { (value) in
            print("Profile Data Api  \(value)")
            Indicator.shared.hideProgressView()
            let msg = (value["message"] as? String ?? "")
            if self.conn.responseCode == 1{
            //  let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                let data = (value["data"] as? [[String:AnyObject]] ?? [[:]])
                
                do{
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
                    self.acceptedReqData = try newJSONDecoder().decode(rides.self, from: jsonData)
                    print(self.acceptedReqData)
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
//MARK:- picker
extension ProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return acceptedReqData.count // number of dropdown items
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return acceptedReqData[row].document_name! // dropdown item
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedservice = acceptedReqData[row].document_name!
        selectedID = acceptedReqData[row].id!
       
    }
}
extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("calling")
            
            if imagePick == "profile" {
                self.userImg.image = pickedImage
                self.img = pickedImage
                kProfileImageUpdateStatus = true
            }
            if imagePick == "doc"{
                self.mImg.image = pickedImage
                self.docimg = pickedImage
                kProfileDOCImageUpdateStatus = true
//                identificationProofImageView.image = pickedImage
//                self.identificationProofImg = pickedImage
            }
            
            
           
        }
        picker.dismiss(animated: true, completion: nil)
    }
  
}
//MARK:- Image Picker Delegate
//extension ProfileViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate , ImagePickerDelegete {
//    func disFinishPicking(imgData: Data, img: UIImage) {
//        self.imageData = imgData
//        self.imageName =  String.uniqueFilename(withSuffix: ".png")
//        self.userImg.image = img
//        self.img = img
//        kProfileImageUpdateStatus = true
//    }
//}
extension ProfileViewController : UITextFieldDelegate {
    
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
        }else if textField == mDocTF{
            if selectedservice == nil{
                if acceptedReqData.count != 0{
                    selectedservice = acceptedReqData[0].document_name!
                  //  IDselected = searchModel.first?.id! as! String
                    selectedID = acceptedReqData[0].id!
                    mDocTF.text = selectedservice
                }
            }else{
                mDocTF.text = selectedservice
            }
        }else if textField == mobile_txtField{
           
            kProfileEditMobile = mobile_txtField.text ?? ""
        }
        kProfileInputStatus = true
       
        
    }
}

extension ProfileViewController : CountryPickerDelegate{
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        //pick up anythink
        self.mCountryTF.text = phoneCode
    }
}


