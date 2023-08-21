//
//  Date.swift
//  AQUA
//
//  Created by malika saini on 22/08/22.
//  Copyright © 2017 MindfulSas. All rights reserved.
//

import Foundation

public extension Date{
    
    //MARK:StringToDate Extensions
    var dateToUTCString:String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone.current
        let utcString = dateFormatter.string(from: self)
        return utcString
    }
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    var dateToSmartDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "d MMMM, yyyy"
        let localDateTimeString = dateFormatter.string(from: self)
        return localDateTimeString
    }
    var GetDate:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "d"
        let localDateTimeString = dateFormatter.string(from: self)
        return localDateTimeString
    }
    var GetMonth:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let localDateTimeString = dateFormatter.string(from: self)
        return localDateTimeString
    }

    var GetDay:String{
        let dateFormatter =  DateFormatter()
        dateFormatter.dateFormat = "EE"
        let localDateTimeString = dateFormatter.string(from: self)
        return localDateTimeString
    }
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    var Month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var Year: Int {
        return Calendar.current.component(.year,  from: self)
    }
    var Day: Int {
        return Calendar.current.component(.day,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return tomorrow.Month != Month
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    var startDateOfMonth: Date {
       return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var endDateOfMonth: Date {
          return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth)!
       }
}


public extension Float {
    func roundTo(places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
    
}

//extension Date {
//    static func dates(from fromDate: Date, to toDate: Date) -> [CalendarModel] {
//        var CalendarData = [CalendarModel]()
//        var CalendarDict = CalendarModel()
//        var date = fromDate
//        while date <= toDate {
//            if CalendarDict.Month != date.Month{
//                if CalendarDict.Month != nil{
//                    CalendarData.append(CalendarDict)
//                }
//                CalendarDict = CalendarModel()
//                CalendarDict.Month = date.Month
//                CalendarDict.Year = date.Year
//                CalendarDict.MonthName = date.GetMonth
//                CalendarDict.Dates.append(date)
//            }
//            else{
//                CalendarDict.Dates.append(date)
//            }
//            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
//            date = newDate
//            print(date)
//        }
//        return CalendarData
//    }
//}
