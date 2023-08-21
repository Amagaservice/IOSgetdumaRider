//
//  PaymentDetailVC.swift
//  Ocory
//
//  Created by nile on 20/09/21.
//

import UIKit
import Stripe
import Alamofire

protocol goBackProtocal {
    func backButtonAction(selectedStatus: Bool )
}

class PaymentDetailVC: UIViewController {
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

    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    var goBackDelegate: goBackProtocal?

    override func viewDidLoad() {
        super.viewDidLoad()
        cardNumberTf.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "green")
        self.setNavButton()

    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            NavigationManager.pushToLoginVC(from: self)
        }
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "Card Detail"
        
    }
    @IBAction func tapCancel_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
            self.showAlert("GetDuma", message: "Please enter card expiry")
            return
        }
        guard let cardCvv = cardCvvTf.text, cardCvv != "" else {
            self.showAlert("GetDuma", message: "Please enter card CVV" )
            return
        }
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

extension PaymentDetailVC : UITextFieldDelegate{
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


