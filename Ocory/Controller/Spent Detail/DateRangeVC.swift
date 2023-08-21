//
//  DateRangeVC.swift
//  OcoryDriver
//
//  Created by nile on 23/09/21.
//

import UIKit


protocol dateRangeVCProtocal {
    func backRangeDateSelectedDate(fromDate: String,toDate: String,selectedStatus: String )
}
class DateRangeVC: UIViewController {
    @IBOutlet weak var fromDateLabel: UITextField!
    @IBOutlet weak var toDateLabel: UITextField!
    fileprivate var _popUpVC = UIViewController()
    var dateSelectStatus = false
    var kFromDate = ""
    var kToDate = ""
    var kSelectedStatus = ""
    var dateRangeVCDelegate: dateRangeVCProtocal?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromDateLabel.datePicker(target: self,
                                          doneAction: #selector(doneAction),
                                          cancelAction: #selector(cancelAction),
                                          datePickerMode: .date)
        self.toDateLabel.datePicker(target: self,
                                          doneAction: #selector(doneToAction),
                                          cancelAction: #selector(cancelToAction),
                                          datePickerMode: .date)
        
    }
    
      @objc
      func cancelAction() {
          self.fromDateLabel.resignFirstResponder()
      }

      @objc
      func doneAction() {
          if let datePickerView = self.fromDateLabel.inputView as? UIDatePicker {
              datePickerView.datePickerMode = .date
              datePickerView.maximumDate = Date()
              if #available(iOS 13.4, *) {
                  datePickerView.preferredDatePickerStyle = .wheels
              } else {
                  // Fallback on earlier versions
              }
              let dateFormatter = DateFormatter()
              dateFormatter.dateFormat = "yyyy-MM-dd"
              let dateString = dateFormatter.string(from: datePickerView.date)
              self.fromDateLabel.text = dateString
              
              print(datePickerView.date)
              print(dateString)
              kFromDate = dateString
              fromDateLabel.isUserInteractionEnabled = false
              self.fromDateLabel.resignFirstResponder()
          }
      }
    
    @objc
    func cancelToAction() {
        self.toDateLabel.resignFirstResponder()
    }

    @objc
    func doneToAction() {
        if let datePickerView = self.toDateLabel.inputView as? UIDatePicker {
            datePickerView.datePickerMode = .date
            datePickerView.maximumDate = Date()
            if #available(iOS 13.4, *) {
                datePickerView.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.toDateLabel.text = dateString
            
            print(datePickerView.date)
            print(dateString)
            kToDate = dateString
            toDateLabel.isUserInteractionEnabled = false
            self.toDateLabel.resignFirstResponder()
        }
    }
    
    
    @IBAction func subnmitBtn(_ sender: Any) {
        print("FROM====\(kFromDate)TO=====\(kToDate)")
        if fromDateLabel.text == "Select From Date"{
            self.showAlert("GetDuma Driver", message: "Please Select From Date")
        }
        if toDateLabel.text == "Select To Date"{
            self.showAlert("GetDuma Driver", message: "Please Select To Date")
        }
        
        
        if kFromDate != "" && kToDate != ""{
            self.dateRangeVCDelegate?.backRangeDateSelectedDate(fromDate: kFromDate, toDate: kToDate, selectedStatus: kSelectedStatus)
            self.dismiss(animated: true, completion: nil)
        }
    }
  
    @IBAction func cancelBtn(_ sender: Any) {
        self.dateRangeVCDelegate?.backRangeDateSelectedDate(fromDate: "", toDate: "", selectedStatus: "")
        self.dismiss(animated: true, completion: nil)
    }
}
