////
////  CalanderPopUpVC.swift
////  OcoryDriver
////
////  Created by nile on 23/09/21.
////
//
//import UIKit
//import FSCalendar
//
//protocol CalanderPopUpProtocal {
//    func backSelectedDate(fromDate: String,toDate: String,selectedStatus: String )
//}
//class CalanderPopUpVC: UIViewController {
//    var calanderPopUpDelegate: CalanderPopUpProtocal?
//
//    @IBOutlet weak var calendarVieww: FSCalendar!
//    fileprivate let formatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter
//    }()
//    var selectedCalendarDate : String?
//    var selectedCalendarDateStatus = false
//    private var firstDate: Date?
//    private var lastDate: Date?
//    private var datesRange: [Date]?
//    var dateFromTo = pickDate.fromDate
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        calendarVieww.today = nil
//        calendarVieww.allowsMultipleSelection = false
//    }
//
//    @IBAction func nextTapped(_ sender:UIButton) {
//        calendarVieww.setCurrentPage(getNextMonth(date: calendarVieww.currentPage), animated: true)
//
//    }
//    @IBAction  func previousTapped(_ sender:UIButton) {
//        calendarVieww.setCurrentPage(getPreviousMonth(date: calendarVieww.currentPage), animated: true)
//    }
//    @IBAction  func doneTapped(_ sender:UIButton) {
//
//        if dateFromTo == .fromDate{
//            calanderPopUpDelegate?.backSelectedDate(fromDate: kFromDate , toDate: "", selectedStatus: pickDate.fromDate.rawValue)
//        }
//        else{
//            calanderPopUpDelegate?.backSelectedDate(fromDate: "", toDate: kToDate, selectedStatus: pickDate.toDate.rawValue)
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
//    //    {
//    //        calendarVieww.removeFromSuperview()
//    //        self.dismiss(animated: true, completion: nil)
//    //    }
//}
//extension CalanderPopUpVC : FSCalendarDelegate,FSCalendarDataSource {
//    func getNextMonth(date:Date)->Date {
//        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
//    }
//
//    func getPreviousMonth(date:Date)->Date {
//        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
//    }
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        // nothing selected:
//
//        if dateFromTo == .fromDate{
//            if firstDate == nil {
//                firstDate = date
//                datesRange = [firstDate!]
//                print("first Date  \(self.formatter.string(from: date))")
//                kFromDate = "\(self.formatter.string(from: date))"
//                //  calanderPopUpDelegate?.backSelectedDate(fromDate: kFromDate , toDate: "", selectedStatus: pickDate.fromDate.rawValue)
//                return
//            }
//        }
//        else{
//            if lastDate == nil {
//                if lastDate == nil {
//                    lastDate = date
//                    datesRange = [lastDate!]
//                    print("second Date  \(self.formatter.string(from: date))")
//                    kToDate = "\(self.formatter.string(from: date))"
//                    //       calanderPopUpDelegate?.backSelectedDate(fromDate: "", toDate: kToDate, selectedStatus: pickDate.toDate.rawValue)
//                    return
//                }
//            }
//        }
//
//
//        // only first date is selected:
//        //        if firstDate != nil && lastDate == nil {
//        //            // handle the case of if the last date is less than the first date:
//        //            if date <= firstDate! {
//        //                calendar.deselect(firstDate!)
//        //                firstDate = date
//        //                datesRange = [firstDate!]
//        //
//        //                print("datesRange contains2: \(datesRange!)")
//        //                let datesRangeString = "\(String(describing: datesRange))"
//        //                print(datesRangeString)
//        //                calanderPopUpDelegate?.backSelectedDate(_selectedDate: datesRangeString, selectedStatus: true)
//        //
//        //                return
//        //            }
//        //
//        //            let range = datesRange(from: firstDate!, to: date)
//        //
//        //            lastDate = range.last
//        //
//        //            for d in range {
//        //                calendar.select(d)
//        //            }
//        //
//        //            datesRange = range
//        //
//        //            print("datesRange contains:3 \(datesRange!)")
//        //            let datesRangeString = "\(String(describing: datesRange))"
//        //            print(datesRangeString)
//        //            calanderPopUpDelegate?.backSelectedDate(_selectedDate: datesRangeString, selectedStatus: true)
//        //
//        //            return
//        //        }
//
//        // both are selected:
//        //        if firstDate != nil && lastDate != nil {
//        //            for d in calendar.selectedDates {
//        //                calendar.deselect(d)
//        //            }
//        //
//        //            lastDate = nil
//        //            firstDate = nil
//        //
//        //            datesRange = []
//        //
//        //            print("datesRange contains4: \(datesRange!)")
//        //            let datesRangeString = "\(String(describing: datesRange))"
//        //            print(datesRangeString)
//        //            calanderPopUpDelegate?.backSelectedDate(_selectedDate: datesRangeString, selectedStatus: true)
//        //        }
//    }
//
//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        // both are selected:
//
//        // NOTE: the is a REDUANDENT CODE:
//        if firstDate != nil && lastDate != nil {
//            for d in calendar.selectedDates {
//                calendar.deselect(d)
//            }
//
//            lastDate = nil
//            firstDate = nil
//
//            datesRange = []
//            print("datesRange contains: \(datesRange!)")
//        }
//    }
//    func datesRange(from: Date, to: Date) -> [Date] {
//        // in case of the "from" date is more than "to" date,
//        // it should returns an empty array:
//        if from > to { return [Date]() }
//
//        var tempDate = from
//        var array = [tempDate]
//
//        while tempDate < to {
//            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
//            array.append(tempDate)
//        }
//
//        return array
//    }
//    /*
//     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//     print("did select date \(self.formatter.string(from: date))")
//
//     }
//     */
//}
//
//
