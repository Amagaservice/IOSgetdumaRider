//
//  Extensions.swift
//  Ocory
//
//  Created by Arun Singh on 22/02/21.
//

import Foundation
import UIKit
import CoreLocation

extension UIViewController {
    
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, pushing: Bool, completion: (() -> Void)? = nil) {
        
        if pushing {
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .fade
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: false, completion: completion)
            
        } else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
        
    }
    
    func showAlertWithBackButton(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismissView()
        }))
        self.present(alert, animated: true)
    }
    func dismissView() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertAction(Title: String , Message: String , ButtonTitle: String) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertWithAction(Title: String , Message: String , ButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        alert.view.tintColor = UIColor.black
        
        alert.addAction(UIAlertAction(title: ButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func showAlertWithActionOkandCancel(Title: String , Message: String , OkButtonTitle: String ,CancelButtonTitle: String ,outputBlock:@escaping ()->Void) {
        
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.view.tintColor = UIColor.black
        alert.addAction(UIAlertAction(title: CancelButtonTitle, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: OkButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
            
            outputBlock()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func getDateFormat(date:Date) -> String {
        let todaysDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        return DateInFormat
    }
    
    func getStringFormat(date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "MMM dd,yyyy"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    func getStringTimeFormat(date:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "Pm"
    //    dateFormatter.dateFormat = "a"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    func showToast(message: String) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 20;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: toastContainer, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
        let lableBottom = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let lableTop = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([centerX, lableBottom, lableTop])
        
        let containerCenterX = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let containerTrailing = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .equal, toItem: toastLabel, attribute: .width, multiplier: 1.1, constant: 0)
        let containerBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
        self.view.addConstraints([containerCenterX,containerTrailing, containerBottom])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}
extension String {
    
    static func uniqueFilename(withSuffix suffix: String? = nil) -> String {
        let uniqueString = ProcessInfo.processInfo.globallyUniqueString
        
        if suffix != nil {
            return "\("OcoryUser-")-\(uniqueString)" + "\(suffix ?? "")"
        }
        
        return uniqueString
    }
    
}
extension String
{
    public func toInt() -> Int? {
        if let num = NumberFormatter().number(from: self) {
            return num.intValue
        } else {
            return nil
        }
    }
      //Converts String to Bool
    public func toBool() -> Bool? {
        return (self as NSString).boolValue
    }
    /// EZSE: Converts String to Double
    public func toDouble() -> Double?
    {
       if let num = NumberFormatter().number(from: self) {
                return num.doubleValue
            } else {
                return nil
            }
     }
    public func toFloat() -> Float?
    {
       if let num = NumberFormatter().number(from: self) {
                return num.floatValue
            } else {
                return nil
            }
     }
}
extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self*0.00062137
    }

    func inKilometers() -> CLLocationDistance {
        return self/1000
    }
}
extension Double {
  func convert(from originalUnit: UnitLength, to convertedUnit: UnitLength) -> Double {
    return Measurement(value: self, unit: originalUnit).converted(to: convertedUnit).value
  }
}
func validateIFSC(code : String) -> Bool {
  let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
  return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
}

extension String {
    func makeCall(phoneNumber: String) {
        let formattedNumber = phoneNumber.components(separatedBy:
                                                        NSCharacterSet.decimalDigits.inverted).joined(separator: "")
        
        let phoneUrl = "tel://\(formattedNumber)"
        let url:NSURL = NSURL(string: phoneUrl)!
        
        if #available(iOS 10, *) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler:
                                        nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
}

extension UITableView {

func setEmptyMessage(_ message: String) {
    let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    messageLabel.text = message
    messageLabel.textColor = #colorLiteral(red: 0.168627451, green: 0.1803921569, blue: 0.2549019608, alpha: 1)
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    messageLabel.font =    UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    messageLabel.sizeToFit()
    self.backgroundView = messageLabel
    self.separatorStyle = .none
}

func removeErrorMessage() {
    self.backgroundView = nil
}
func scrollTableViewToBottom(animated: Bool) {
    guard let dataSource = dataSource else { return }

    var lastSectionWithAtLeasOneElements = (dataSource.numberOfSections?(in: self) ?? 1) - 1

    while dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) < 1 {
        lastSectionWithAtLeasOneElements -= 1
    }

    let lastRow = dataSource.tableView(self, numberOfRowsInSection: lastSectionWithAtLeasOneElements) - 1

    guard lastSectionWithAtLeasOneElements > -1 && lastRow > -1 else { return }

    let bottomIndex = IndexPath(item: lastRow, section: lastSectionWithAtLeasOneElements)
    scrollToRow(at: bottomIndex, at: .bottom, animated: animated)
}
}
