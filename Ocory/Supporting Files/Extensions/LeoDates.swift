//
//  LeoDates.swift
//  Ocory
//
//  Created by nile on 13/09/21.
//

import Foundation
class  LeoDates {
    var suggestedFormates : [String] =  ["yyyy-MM-dd hh:mm:ss" ,
                                         "dd-MM-yyyy hh:mm:ss" ,
                                         "yyyy-MM-dd" , "yyyy-MM-dd'T'HH:mm:ssZ"]
    static let share = LeoDates()
    func addFormat(_ format :String) {
        LeoDates.share.suggestedFormates.append(format)
    }
}


extension String {
    func timeInNum() -> Int {
        let timeIntArr = self.components(separatedBy: ":").map({Int($0)!})
        let hr = timeIntArr[0] * 60 * 60
        let min = timeIntArr[1] * 60
        let sec = timeIntArr[2]
        let totalIntervals = hr + min + sec
        return totalIntervals
    }
    
    func convertLondonTime() -> String {
        let df = DateFormatter()
        df.timeZone = TimeZone(abbreviation: "EDT")
//        df.timeZone = TimeZone(abbreviation: "BST")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: self)
        df.timeZone = TimeZone.current
        df.dateFormat = "HH:mm:ss"
        if let date = date {
            let dd = df.string(from: date)
            print("DD : \(dd)")
            return dd
        }
        return ""
    }
    
    
    func convertLondonDateTime() -> Date? {
        let df = DateFormatter()
//                df.timeZone = TimeZone(abbreviation: "EDT")
        df.timeZone = TimeZone(abbreviation: "BST")
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = df.date(from: self)
        df.timeZone = TimeZone.current
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = date {
            let dd = df.string(from: date)
            let currentServerDate = df.date(from: dd)
            print("Current Server Date Obj : \(currentServerDate!)")
            return currentServerDate
        }
        return nil
    }
    
    func convertSessionTimeWithDateObj(learnerTimeZone: String, bookingDate: String, sessionTime: Int, showTimeFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let df = DateFormatter()
        df.timeZone = TimeZone(identifier: learnerTimeZone)
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let booking_date = bookingDate//.convertUTCToLocal()
        let bookDateTime = booking_date + " " + self
        
        let date = df.date(from: bookDateTime)
        let sessionEndDateTime = date?.addingTimeInterval(TimeInterval(sessionTime))
        print("Start Sess Date Obj: \(date!)")
        print("Start Sess Date Obj: \(sessionEndDateTime!)")
        
        df.timeZone = TimeZone.current
        df.dateFormat = showTimeFormat
        if let sessionEndDateTime = sessionEndDateTime {
            //            let addingHourTime = Calendar.current.date(byAdding: .hour, value: 0, to: date)
            let dd = df.string(from: sessionEndDateTime)
            let sessionDateObj = df.date(from: dd)
            print("SessionDateObj : \(sessionDateObj!)")
            return sessionDateObj
        }
        return nil
    }
    
    func convertTZToCurrentTZ(timezone: String, bookingDate: String, showTimeFormat: String = "HH:mm a") -> String {
        let df = DateFormatter()
//        df.timeZone = TimeZone(abbreviation: learnerTimeZone)
        df.timeZone = TimeZone(identifier: timezone)
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let booking_date = bookingDate//.convertUTCToLocal()
        let bookDateTime = booking_date + " " + self
        
        let date = df.date(from: bookDateTime)
        df.timeZone = TimeZone.current
        df.dateFormat = showTimeFormat
        if let date = date {
//            let addingHourTime = Calendar.current.date(byAdding: .hour, value: 0, to: date)
            let dd = df.string(from: date)
            //print("Current Device Time : \(dd)")
            return dd
        }
        return ""
    }
    
    func convertUTCToLocal() -> String {
        let df1 = DateFormatter()
        df1.timeZone = TimeZone(abbreviation: "UTC")
        df1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        let book_date = df1.date(from: self)
        df1.dateFormat = "dd/MM/yyyy"
        let bookDateStr = df1.string(from: book_date!)
        //print("======\(bookDateStr)===========")
        return bookDateStr
    }
    
}





extension String {
    
    func leoDate(toFormat : String? = nil  ) -> Date {
        for object in LeoDates.share.suggestedFormates {
            let formatter1 = DateFormatter()
            formatter1.timeZone = TimeZone(abbreviation: "UTC")
            formatter1.dateFormat = object
            if let dd1StartDate = formatter1.date(from: self){
                if toFormat == nil {
                    return dd1StartDate
                    
                } else {
                    formatter1.dateFormat = toFormat
                    let some = formatter1.string(from: dd1StartDate)
                    formatter1.dateFormat = toFormat
                    return formatter1.date(from: some)!
                }
            }
        }
        print("#warning : Not a proper Date")
        return Date()
    }
    func leoDateString(toFormat : String? = nil  ) -> String {
        for object in LeoDates.share.suggestedFormates {
            let formatter1 = DateFormatter()
            formatter1.timeZone = TimeZone(abbreviation: "UTC")
            formatter1.dateFormat = object
            
            if let dd1StartDate = formatter1.date(from: self){
                
                if toFormat == nil {
                    return "\(dd1StartDate)"
                } else {
                    
                    formatter1.dateFormat = toFormat
                    
                    let some = formatter1.string(from: dd1StartDate)
                    
                    
                    return some
                }
            }
        }
        print("#warning : Not a proper Date")
        return "\(Date())"
    }
    
    func timeAgoFormat() -> String {
        let dateDate = self.leoDate()
        let unixTime = dateDate.timeIntervalSinceNow
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .weekday, .day, .hour, .minute, .second]
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: -unixTime)!
    }
    
    func convertUTCDateToLocalStr(format: String) -> String {
      //  let ddFormat = self.replacingOccurrences(of: "+00:00", with: " 000Z")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        let dateDate = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        if let dateD = dateDate {
            return dateFormatter.string(from: dateD)
        }
        return ""
    }
    
    func convertUTCDateToLocal(format: String) -> Date? {
      //  let ddFormat = self.replacingOccurrences(of: "+00:00", with: " 000Z")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    
    func getFormattedDateNew(format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: self)
        }
    
    func leoDate(toFormat : String? = nil  ) -> Date {
        if toFormat == nil {
            return self
        }
        let formatter1 = DateFormatter()
        
        formatter1.timeZone = TimeZone(abbreviation: "UTC")
        
        formatter1.dateFormat = toFormat
        
        let some = formatter1.string(from: self)
        
        formatter1.dateFormat = toFormat
        if let dd1StartDate = formatter1.date(from: some){
            return dd1StartDate
        }
        print("#warning : Not a proper Date")
        return self
    }
    func leoDateString(toFormat : String? = nil  ) -> String {
        if toFormat == nil {
            return "\(self)"
        }
        
        let formatter1 = DateFormatter()
        formatter1.timeZone = TimeZone(abbreviation: "UTC")
        formatter1.dateFormat = toFormat
        let some = formatter1.string(from: self)
        return some
    }
}
extension  LeoDates {
    enum Format {
        
        case mmDDYYYYYhhmma
        
        case yyyyMMddHHmmSSZ
        
        case yyyyMMddHHmmSS
        // "2017-11-08 10:18:03"
        
        case hhmma
        
        case mmDDYYYYY
        
        case ddMMYYYYYhhmma
        
        case yyyyMMdd
        
        var name: String {
            
            switch self {
                
            case .mmDDYYYYYhhmma: return "MM-dd-yyyy hh:mm a"
            case .yyyyMMddHHmmSS: return "yyyy-MM-dd HH:mm:ss "
                
                // "2017-11-08 10:18:03"
                
            case .mmDDYYYYY: return "MM-dd-yyyy"
                
            case .yyyyMMdd : return "yyyy-MM-dd"
                
            case .ddMMYYYYYhhmma: return "dd-MM-yyyy hh:mm a"
                
            case .yyyyMMddHHmmSSZ: return "yyyy-MM-dd HH:mm:ss Z"
                
                // "2019-03-30T06:21:28.000Z  ->   "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                
            // case . yyyy-MM-dd'T'HH:mm:ssZ return "yyyy-MM-dd'T'HH:mm:ssZ"
            case .hhmma: return "hh:mm a"
            }
        }
    }
}

extension Date {

    func dayDifference( format : String? = LeoDates.Format.yyyyMMddHHmmSSZ.name , to : String? = LeoDates.Format.mmDDYYYYY.name ) -> String {

        let calendar = NSCalendar.current
        
        if calendar.isDateInYesterday(self) { return "Yesterday" }
            
        else if calendar.isDateInToday(self) { return "Today" }
            
        else if calendar.isDateInTomorrow(self) { return "Tomorrow" }
            
        else {
            
            return    "\(self)".dateToDate(from: format!, to: to!)
            
        }
    }
    
    func smartFormat(fromDate : Date? = Date()) -> String {
        
        
        return self.timeIntervalSinceNow.smartFormat()
    }
}

extension Double {
    
    private func secondsToHoursMinutesSeconds () -> (Int?, Int?, Int?) {
        
        let hrs = self / 3600
        
        let mins = (self.truncatingRemainder(dividingBy: 3600)) / 60
        
        let seconds = (self.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)
        
        return (Int(hrs) > 0 ? Int(hrs) : nil, Int(mins) > 0 ? Int(mins) : nil, Int(seconds) > 0 ? Int(seconds) : nil)
    }
    
    func smartFormat () -> String {
        
        let time = self.secondsToHoursMinutesSeconds()
        
        switch time {
            
        case (nil, let x?, let y?):
            
            return "\(x) min \(y) sec"
            
        case (nil, let x?, nil):
            
            return "\(x) min"
            
        case (let x?, nil, nil):
            
            return "\(x) hr"
            
        case (nil, nil, let x?):
            
            return "\(x) sec"
            
        case (let x?, nil, let z?):
            
            return "\(x) hr \(z) sec"
            
        case (let x?, let y?, nil):
            
            return "\(x) hr \(y) min"
            
        case (let x?, let y?, let z?):
            
            return "\(x) hr \(y) min \(z) sec"
            
        default:
            
            return "\(self)"
        }
    }
}

extension String {
    
    func dateToDate(from: String, to: String) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = from
        
        dateFormatter.timeZone = NSTimeZone.local
        
        guard let date = dateFormatter.date(from: self) else {
            
            assert(false, "no date from string")
            
            return ""
            
        }
        dateFormatter.dateFormat = to
        
        dateFormatter.timeZone = NSTimeZone.local
        
        let timeStamp = dateFormatter.string(from: date)
        
        return timeStamp
    }
    
    func date(format: String) -> Date? {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        formatter.timeZone = NSTimeZone.local
        
        return formatter .date(from: self)
    }
    
    func stringtoDate(format: String) -> Date? {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        formatter.timeZone = NSTimeZone.local
        
        return formatter .date(from: self)
    }
    
    
}
