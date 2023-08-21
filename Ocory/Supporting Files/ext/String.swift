//
//  String.swift
//  AQUA
//
//  Created by malika on 22/08/22.
//  Copyright © 2017 MindfulSas. All rights reserved.
//

import Foundation
import UIKit
extension String{
    //MARK:Length of String
    var length :Int{
        return (self as NSString).length
    }
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    var isValidPhoneNumber: Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    //  func dropLast(_ n: Int = 1) -> String {
    //    return String(characters.dropLast(n))
    //  }
    //  var dropLast: String {
    //    return dropLast()
    //  }
    
    //MARK: Making first letter lower of String
    var camelCase:String{
        var result = self
        result.replaceSubrange(self.startIndex...self.startIndex, with: String(self[self.startIndex]).lowercased())
        //result.replaceSubrange(1...1, with: String(self[startIndex]).lowercased())
        return result
    }
    
    //MARK:Making First letter capital of Name
    var toProper:String {
        let result = self
        return (result.capitalized(with: NSLocale.current))
    }
    
    //MARK:Making First letter capital of Name
    var makeFirstLetterCapital:String {
        var result = lowercased()
        result.replaceSubrange(self.startIndex...self.startIndex, with: String(self[startIndex]).capitalized)
        return result
    }
    
    
    //MARK:Localising String
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    //MARK:JSONStringToDate
    var jsonStringToDate:NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcDate = dateFormatter.date(from: self)
        return utcDate! as NSDate
    }
    //MARK:StringToDate Extensions
    var dateStringToUTCString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let utcDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcString = dateFormatter.string(from: utcDate!)
        return utcString
    }
    
    var utcStringToSmartDate2:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "MM/dd/yy"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringToSmartDate12:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "EE, MMM dd"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringToSmartDate1222:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "EEEE, MMM dd"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var graphStyleDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "dd MM, yyyy"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "d MMM"
        let dayName = dateFormatter.string(from: date!)
        
        return(dayName)
        
    }
    var graphStyle:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "d MMM"
        let dayName = dateFormatter.string(from: date!)
        
        return(dayName)
        
    }
    var convertNextDate: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let myDate = dateFormatter.date(from: self)!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: myDate)
        let somedateString = dateFormatter.string(from: tomorrow!)
        print("your next Date is \(somedateString)")
        return somedateString
    }
    var commondateStringToUTCString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
        let utcDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcString = dateFormatter.string(from: utcDate!)
        return utcString
    }
    var MothnStringToUTCString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let utcDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMMM dd,yyyy"
        let utcString = dateFormatter.string(from: utcDate!)
        return utcString
    }
    var utcStringToDateString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        let localDateString = dateFormatter.string(from: localDate!)
        return localDateString
    }
    var utcStringTo12:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let localDateString = dateFormatter.string(from: localDate!)
        return localDateString
    }
    var utcStringTojoined:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let localDateString = dateFormatter.string(from: localDate!)
        return localDateString
    }
    var WeekutcString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EEEE, MMM dd, yyyy"
        let localDateString = dateFormatter.string(from: localDate!)
        return localDateString
    }
    var utcToString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    
    var timeOnly:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "h:mm a"
        let localDateString = dateFormatter.string(from: localDate!)
        return localDateString
    }
    
    var utcStringToSmartDate5:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utctoMonth:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MM"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utctoYear:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utctoDay:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringEarning:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM, yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcDonationString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM, yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToDateTime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd MMM • h:mm a"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    
    var cretaescreen:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var Dateonly:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var editPscreen:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var endtime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let localDate = dateFormatter.date(from: self)
        let currentDate = NSDate()
        //dateFormatter.dateFormat = "MMM-dd-yyyy"
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToSmarttime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    
    var PutctoString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM, yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    
    var utcStringToSmartDAtetime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd/MM/yy , hh:mm a"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToDateandtime:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a "
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToD:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd/MM/yy , hh:mm a"
        
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToSmartDate55:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSSS"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "EEEE, MMMM d"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    
    var utcStringToSmartDat:String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDate = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "d MMM, yyyy"
        let dateString = dateFormatter.string(from: localDate!)
        return dateString
    }
    var utcStringToSmartDate:String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "eee,MMMM d"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
        
    }
    var utcStringTo:String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringTo1:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringToSmartDate3:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "eee"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    var utcStringToLocalDateTime:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "hh:mm a"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringToLocalDateTime1:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "h:mm a"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var utcStringToLocalDateTime11:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "h:mm a"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
    }
    var clipTitle:String {
        var clipedName = self
        if clipedName.count > 18{
            if let range = clipedName.range(of: " ") {
                let firstPart = clipedName[clipedName.startIndex..<range.lowerBound]
                clipedName = String(firstPart)
            }
        }
        return clipedName
    }
    var utcStringToTimeDifference:String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        var comp = Set<Calendar.Component>()
        comp.insert(.minute)
        //   let difference  = NSCalendar.current.dateComponents(, from: date, to: self)
        let myNewDate = Date()
        let difference  =   Calendar.current.dateComponents(comp, from:date1! , to: myNewDate).minute ?? 0
        
        let hours = difference / 60
        let min = difference % 60
        return "\(String(hours))h \(String(min))m"
    }
    
    func dateDifference(toDate: String) -> String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        let date2  = dateFormatter.date(from: toDate)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        var comp = Set<Calendar.Component>()
        comp.insert(.minute)
        
        let difference = Calendar.current.dateComponents(comp, from:date1! , to: date2!).minute ?? 0
        
        let hours = difference / 60
        let min = difference % 60
        return "\(String(hours))h \(String(min))m"
        
    }
    
    func workingHourDifference(workMinutes:Int ) -> String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        var comp = Set<Calendar.Component>()
        comp.insert(.minute)
        
        let myNewDate = Date()
        var difference  =   Calendar.current.dateComponents(comp, from:date1! , to: myNewDate).minute ?? 0
        difference = difference + workMinutes
        
        let hours = difference / 60
        let min = difference % 60
        return "\(String(hours))h \(String(min))m"
        
    }
    
    
    
    var utcStringToLocalDateTimeForNotification:String {
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angeles
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "d MMMM yyyy, h:mm a"
        let localDateTimeString = dateFormatter.string(from: date1!)
        return localDateTimeString
        
    }
    
    var httpsExtend:String{
        if self.contains("https") == true{
            return self
        }
        let newString = self.replacingOccurrences(of: "http", with: "https", options: .literal, range: nil)
        return newString
    }
    
    var withoutHttpsExtend:String{
        if self.contains("http") == true{
            return self
        }
        let newString = self.replacingOccurrences(of: "http", with: "http", options: .literal, range: nil)
        return newString
    }
    
    
    
    var utcStringToTimeName:String{
        
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "h:mm a"
        let monthName = dateFormatter.string(from: date!)
        return(monthName)
    }
    var utcStringValidTillDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "eee dd,yyyy"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    var utcStringValidTillDate12:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    var utcStringToDayName:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "EEE"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
        
    }
    
    var hhmmTo12:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        return Date12
    }
    var hmToHHmm:String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "HH:mm"
        
        let Date24 = dateFormatter.string(from: date!)
        print("24 hour formatted Date:",Date24)
        return Date24
    }
    var utcStringToFullDayName:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "HH:mm a"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
        
    }
    var utcStringToShortDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "MMM d"
        let dayName = dateFormatter.string(from: date!)
        
        return(dayName)
        
    }
    var utcStringToShortDate111:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "EEEE, MMM d"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    
    var stringtoutc :String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyyhh:mm a"
        let date = dateFormatter.date(from: self)
        //   print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    
    var stringtoutc2 :String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: self)
        //   print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    
    
    var stringTimetoutc : String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "HH:mm:ss"
        let dayName = dateFormatter.string(from: date!)
        return(dayName)
    }
    
    var shortStyleDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        let date = dateFormatter.date(from: self)
        print(date!)
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "d MMM,"
        let dayName = dateFormatter.string(from: date!)
        
        return(dayName)
        
    }
    var getYear:String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: date!)
        return year
    }
    
    var getMonth:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "MM"
        let year = dateFormatter.string(from: date!)
        return year
        
    }
    var getDay:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "dd"
        let year = dateFormatter.string(from: date!)
        return year
        
    }
    
    var getHour:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "HH"
        let year = dateFormatter.string(from: date!)
        return year
    }
    
    
    var getMintue:String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "mm"
        let year = dateFormatter.string(from: date!)
        return year
        
    }
    
    var subStringfromUTCStrnig:String {
        
        let c = self
        let r = c.index(c.startIndex, offsetBy: 11)..<c.index(c.endIndex, offsetBy: -12)
        
        // Access the string by the range.
        let substring = self[r]
        return String(substring)
        
        
    }
    
    func dateTimeToTodayTime() -> String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateUtc = dateFormatter.string(from: Date())
        var myDateArr = dateUtc.components(separatedBy: "T")
        var compDateArr = self.components(separatedBy: "T")
        let newDate = myDateArr[0] + "T" + compDateArr[1]
        return newDate
        
    }
    
    
    var dateFromUTCString:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angelesdate
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "dd"
        let localDateString = dateFormatter.string(from: date1!)
        return localDateString
        
        
        //        let c = self.characters
        //        let r = c.index(c.startIndex, offsetBy: 8)..<c.index(c.endIndex, offsetBy: -14)
        //
        //        // Access the string by the range.
        //        let substring = self[r]
        //        return substring
        
        
    }
    
    var orderDate:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angelesdate
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "MMM dd,h:mm a"
        let localDateString = dateFormatter.string(from: date1!)
        return localDateString
        
        
        //        let c = self.characters
        //        let r = c.index(c.startIndex, offsetBy: 8)..<c.index(c.endIndex, offsetBy: -14)
        //
        //        // Access the string by the range.
        //        let substring = self[r]
        //        return substring
        
        
    }
    
    var orderDate1:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angelesdate
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        
        dateFormatter.dateFormat = "yyyy MMM dd"
        let localDateString = dateFormatter.string(from: date1!)
        return localDateString
        
        
        //        let c = self.characters
        //        let r = c.index(c.startIndex, offsetBy: 8)..<c.index(c.endIndex, offsetBy: -14)
        //
        //        // Access the string by the range.
        //        let substring = self[r]
        //        return substring
        
        
    }
    
    
    var selectedPickerDatetoUTC:String {
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date1 = dateFormatter.date(from: self)
        // return the timeZone of your device i.e. America/Los_angelesdate
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let localDateString = dateFormatter.string(from: date1!)
        return localDateString
        //        let c = self.characters
        //        let r = c.index(c.startIndex, offsetBy: 8)..<c.index(c.endIndex, offsetBy: -14)
        //
        //        // Access the string by the range.
        //        let substring = self[r]
        //        return substring
        
    }
    
    
    
    //MARK: find Width of String
    func widthWithConstrainedWidth(hieght: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: hieght)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.width
    }
    
    
    var html: String {
        
        get {
            //"&":"&amp;", add it for & operation
            
            let enc:  [Character:String] = [" ":"%20","^":"%5E", " ":"&ensp;", " ":"%20", " ":"&thinsp;", "‾":"&oline;", "–":"&ndash;", "—":"&mdash;", "¡":"&iexcl;", "¿":"&iquest;", "…":"&hellip;", "·":"&middot;", "'":"&apos;", "‘":"&lsquo;", "’":"&rsquo;", "‚":"&sbquo;", "‹":"&lsaquo;", "›":"&rsaquo;", "‎":"&lrm;", "‏":"&rlm;", "­":"&shy;", "‍":"&zwj;", "‌":"&zwnj;", "\"":"&quot;", "“":"&ldquo;", "”":"&rdquo;", "„":"&bdquo;", "«":"&laquo;", "»":"&raquo;", "⌈":"&lceil;", "⌉":"&rceil;", "⌊":"&lfloor;", "⌋":"&rfloor;", "〈":"&lang;", "〉":"&rang;", "§":"&sect;", "¶":"&para;", "‰":"&permil;", "†":"&dagger;", "‡":"&Dagger;", "•":"&bull;", "′":"&prime;", "″":"&Prime;", "´":"&acute;", "˜":"&tilde;", "¯":"&macr;", "¨":"&uml;", "¸":"&cedil;", "ˆ":"&circ;", "°":"&deg;", "©":"&copy;", "®":"&reg;", "℘":"&weierp;", "←":"&larr;", "→":"&rarr;", "↑":"&uarr;", "↓":"&darr;", "↔":"&harr;", "↵":"&crarr;", "⇐":"&lArr;", "⇑":"&uArr;", "⇒":"&rArr;", "⇓":"&dArr;", "⇔":"&hArr;", "∀":"&forall;", "∂":"&part;", "∃":"&exist;", "∅":"&empty;", "∇":"&nabla;", "∈":"&isin;", "∉":"&notin;", "∋":"&ni;", "∏":"&prod;", "∑":"&sum;", "±":"&plusmn;", "÷":"&divide;", "×":"&times;", "<":"&lt;", "≠":"&ne;", ">":"&gt;", "¬":"&not;", "¦":"&brvbar;", "−":"&minus;", "⁄":"&frasl;", "∗":"&lowast;", "√":"&radic;", "∝":"&prop;", "∞":"&infin;", "∠":"&ang;", "∧":"&and;", "∨":"&or;", "∩":"&cap;", "∪":"&cup;", "∫":"&int;", "∴":"&there4;", "∼":"&sim;", "≅":"&cong;", "≈":"&asymp;", "≡":"&equiv;", "≤":"&le;", "≥":"&ge;", "⊄":"&nsub;", "⊂":"&sub;", "⊃":"&sup;", "⊆":"&sube;", "⊇":"&supe;", "⊕":"&oplus;", "⊗":"&otimes;", "⊥":"&perp;", "⋅":"&sdot;", "◊":"&loz;", "♠":"&spades;", "♣":"&clubs;", "♥":"&hearts;", "♦":"&diams;", "¤":"&curren;", "¢":"&cent;", "£":"&pound;", "¥":"&yen;", "€":"&euro;", "¹":"&sup1;", "½":"&frac12;", "¼":"&frac14;", "²":"&sup2;", "³":"&sup3;", "¾":"&frac34;", "á":"&aacute;", "Á":"&Aacute;", "â":"&acirc;", "Â":"&Acirc;", "à":"&agrave;", "À":"&Agrave;", "å":"&aring;", "Å":"&Aring;", "ã":"&atilde;", "Ã":"&Atilde;", "ä":"&auml;", "Ä":"&Auml;", "ª":"&ordf;", "æ":"&aelig;", "Æ":"&AElig;", "ç":"&ccedil;", "Ç":"&Ccedil;", "ð":"&eth;", "Ð":"&ETH;", "é":"&eacute;", "É":"&Eacute;", "ê":"&ecirc;", "Ê":"&Ecirc;", "è":"&egrave;", "È":"&Egrave;", "ë":"&euml;", "Ë":"&Euml;", "ƒ":"&fnof;", "í":"&iacute;", "Í":"&Iacute;", "î":"&icirc;", "Î":"&Icirc;", "ì":"&igrave;", "Ì":"&Igrave;", "ℑ":"&image;", "ï":"&iuml;", "Ï":"&Iuml;", "ñ":"&ntilde;", "Ñ":"&Ntilde;", "ó":"&oacute;", "Ó":"&Oacute;", "ô":"&ocirc;", "Ô":"&Ocirc;", "ò":"&ograve;", "Ò":"&Ograve;", "º":"&ordm;", "ø":"&oslash;", "Ø":"&Oslash;", "õ":"&otilde;", "Õ":"&Otilde;", "ö":"&ouml;", "Ö":"&Ouml;", "œ":"&oelig;", "Œ":"&OElig;", "ℜ":"&real;", "š":"&scaron;", "Š":"&Scaron;", "ß":"&szlig;", "™":"&trade;", "ú":"&uacute;", "Ú":"&Uacute;", "û":"&ucirc;", "Û":"&Ucirc;", "ù":"&ugrave;", "Ù":"&Ugrave;", "ü":"&uuml;", "Ü":"&Uuml;", "ý":"&yacute;", "Ý":"&Yacute;", "ÿ":"&yuml;", "Ÿ":"&Yuml;", "þ":"&thorn;", "Þ":"&THORN;", "α":"&alpha;", "Α":"&Alpha;", "β":"&beta;", "Β":"&Beta;", "γ":"&gamma;", "Γ":"&Gamma;", "δ":"&delta;", "Δ":"&Delta;", "ε":"&epsilon;", "Ε":"&Epsilon;", "ζ":"&zeta;", "Ζ":"&Zeta;", "η":"&eta;", "Η":"&Eta;", "θ":"&theta;", "Θ":"&Theta;", "ϑ":"&thetasym;", "ι":"&iota;", "Ι":"&Iota;", "κ":"&kappa;", "Κ":"&Kappa;", "λ":"&lambda;", "Λ":"&Lambda;", "µ":"&micro;", "μ":"&mu;", "Μ":"&Mu;", "ν":"&nu;", "Ν":"&Nu;", "ξ":"&xi;", "Ξ":"&Xi;", "ο":"&omicron;", "Ο":"&Omicron;", "π":"&pi;", "Π":"&Pi;", "ϖ":"&piv;", "ρ":"&rho;", "Ρ":"&Rho;", "σ":"&sigma;", "Σ":"&Sigma;", "ς":"&sigmaf;", "τ":"&tau;", "Τ":"&Tau;", "ϒ":"&upsih;", "υ":"&upsilon;", "Υ":"&Upsilon;", "φ":"&phi;", "Φ":"&Phi;", "χ":"&chi;", "Χ":"&Chi;", "ψ":"&psi;", "Ψ":"&Psi;", "ω":"&omega;", "Ω":"&Omega;", "ℵ":"&alefsym;"]
            
            var html = ""
            for c in self {
                if let entity = enc[c] {
                    html.append(entity)
                } else {
                    html.append(c)
                }
            }
            return html
        }
    }
}
extension NSMutableAttributedString {
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "KoHo-Light", size:12), range: range)
    }
    func setColorAndFont(textForAttribute: String, withColor color: UIColor,fontSize:Int) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "KoHo-Medium", size:CGFloat(fontSize))!, range: range)
    }
}
