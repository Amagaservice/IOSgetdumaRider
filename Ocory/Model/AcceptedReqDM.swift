//
//  AcceptedReqDM.swift
//  Ocory
//
//  Created by Arun Singh on 02/03/21.
//

import Foundation
import UIKit
// MARK: - WelcomeElement
struct RidesData: Codable {
    let rideID, userID: String?
    let driverID: String?
    let pickupAdress: String?
    let dropAddress: String?
    let pikupLocation, pickupLat, pickupLong: String?
    let dropLocatoin: String?
    let dropLat, dropLong, distance: String?
    let status: String?
    let paymentStatus, payDriver, paymentMode, amount: String?
    let time, userMobile: String?
    let userAvatar: String?
    let driverAvatar: String?
    let userName: String?
    let driverMobile, driverName: String?
    let vehicleTypeName: String?
    let audio: [Audio]?
    let document_name: String?
    let id: String?
    let question: String?

    enum CodingKeys: String, CodingKey {
        case rideID = "ride_id"
        case question = "question"
        case userID = "user_id"
        case driverID = "driver_id"
        case pickupAdress = "pickup_adress"
        case dropAddress = "drop_address"
        case pikupLocation = "pikup_location"
        case pickupLat = "pickup_lat"
        case pickupLong = "pickup_long"
        case dropLocatoin = "drop_locatoin"
        case dropLat = "drop_lat"
        case dropLong = "drop_long"
        case distance, status
        case paymentStatus = "payment_status"
        case payDriver = "pay_driver"
        case paymentMode = "payment_mode"
        case amount, time
        case userMobile = "user_mobile"
        case userAvatar = "user_avatar"
        case driverAvatar = "driver_avatar"
        case userName = "user_name"
        case driverMobile = "driver_mobile"
        case driverName = "driver_name"
        case document_name = "document_name"
        case id = "id"
        case vehicleTypeName = "vehicle_type_name"
        case audio
    }
}
// MARK: - Audio
struct Audio: Codable {
    let audio: String?
}
//enum Drop: String, Codable {
//    case noidaSector18NoidaUttarPradesh201301India = "Noida Sector 18, Noida, Uttar Pradesh 201301, India"
//    case rampurUttarPradesh244901India = "Rampur, Uttar Pradesh 244901, India"
//    case saiyadrajaUttarPradesh232110India = "Saiyadraja, Uttar Pradesh 232110, India"
//}
//
//enum Status: String, Codable {
//    case accepted = "ACCEPTED"
//    case startRide = "START_RIDE"
//}
//
//enum UserAvatar: String, Codable {
//    case the1614679847OcoryjpgJpg = "1614679847ocoryjpg.jpg"
//}
//
//enum UserName: String, Codable {
//    case vibhutiUser = "Vibhuti User"
//}

typealias rides = [RidesData]
