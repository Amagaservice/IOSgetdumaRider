//
//  LastRide.swift
//  Ocory
//
//  Created by nile on 29/09/21.
//

import Foundation
struct LastRideModal : Codable {
    let ride_id : String?
    let user_id : String?
    let driver_id : String?
    let vehicle_type_id : String?
    let pickup_adress : String?
    let is_destination_ride : String?
    let drop_address : String?
    let pikup_location : String?
    let pickup_lat : String?
    let pickup_long : String?
    let drop_locatoin : String?
    let drop_lat : String?
    let drop_long : String?
    let distance : String?
    let status : String?
    let is_technical_issue : String?
    let cancelled_by : String?
    let cancelled_count : String?
    let payment_status : String?
    let pay_driver : String?
    let payment_mode : String?
    let amount : String?
    let time : String?
    let driver_name : String?
    let profile_pic : String?
    let vehicle_image : String?
    let user_profile_pic : String?
    let total_rating : String?
    let total_driver_ride : String?
    let latitude : String?
    let user_name : String?
    let longitude : String?
    let mobile : String?
    let feedback : String?
    let total_time : String?
    let total_distance : String?
    let total_arrival_distance : String?
    let total_arrival_time : String?

    let cancellation_charge : String?
    enum CodingKeys: String, CodingKey {

        case ride_id = "ride_id"
        case user_id = "user_id"
        case driver_id = "driver_id"
        case vehicle_image = "vehicle_image"
        case vehicle_type_id = "vehicle_type_id"
        case pickup_adress = "pickup_adress"
        case is_destination_ride = "is_destination_ride"
        case drop_address = "drop_address"
        case pikup_location = "pikup_location"
        case pickup_lat = "pickup_lat"
        case pickup_long = "pickup_long"
        case drop_locatoin = "drop_locatoin"
        case drop_lat = "drop_lat"
        case drop_long = "drop_long"
        case distance = "distance"
        case status = "status"
        case cancelled_by = "cancelled_by"
        case cancelled_count = "cancelled_count"
        case payment_status = "payment_status"
        case pay_driver = "pay_driver"
        case payment_mode = "payment_mode"
        case amount = "amount"
        case time = "time"
        case driver_name = "driver_name"
        case profile_pic = "profile_pic"
        case user_profile_pic = "user_profile_pic"
        case total_rating = "total_rating"
        case total_driver_ride = "total_driver_ride"
        case latitude = "latitude"
        case user_name = "user_name"
        case longitude = "longitude"
        case mobile = "mobile"
        case feedback = "feedback"
        case total_time = "total_time"
        case total_distance = "total_distance"
        case total_arrival_distance = "total_arrival_distance"
        case total_arrival_time = "total_arrival_time"
        case is_technical_issue = "is_technical_issue"
        case cancellation_charge = "cancellation_charge"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ride_id = try values.decodeIfPresent(String.self, forKey: .ride_id)
        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
        user_id = try values.decodeIfPresent(String.self, forKey: .user_id)
        driver_id = try values.decodeIfPresent(String.self, forKey: .driver_id)
        vehicle_type_id = try values.decodeIfPresent(String.self, forKey: .vehicle_type_id)
        pickup_adress = try values.decodeIfPresent(String.self, forKey: .pickup_adress)
        is_destination_ride = try values.decodeIfPresent(String.self, forKey: .is_destination_ride)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        pikup_location = try values.decodeIfPresent(String.self, forKey: .pikup_location)
        pickup_lat = try values.decodeIfPresent(String.self, forKey: .pickup_lat)
        pickup_long = try values.decodeIfPresent(String.self, forKey: .pickup_long)
        drop_locatoin = try values.decodeIfPresent(String.self, forKey: .drop_locatoin)
        drop_lat = try values.decodeIfPresent(String.self, forKey: .drop_lat)
        drop_long = try values.decodeIfPresent(String.self, forKey: .drop_long)
        distance = try values.decodeIfPresent(String.self, forKey: .distance)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        is_technical_issue = try values.decodeIfPresent(String.self, forKey: .is_technical_issue)

        cancelled_by = try values.decodeIfPresent(String.self, forKey: .cancelled_by)
        cancelled_count = try values.decodeIfPresent(String.self, forKey: .cancelled_count)
        payment_status = try values.decodeIfPresent(String.self, forKey: .payment_status)
        pay_driver = try values.decodeIfPresent(String.self, forKey: .pay_driver)
        payment_mode = try values.decodeIfPresent(String.self, forKey: .payment_mode)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        driver_name = try values.decodeIfPresent(String.self, forKey: .driver_name)
        profile_pic = try values.decodeIfPresent(String.self, forKey: .profile_pic)
        user_profile_pic = try values.decodeIfPresent(String.self, forKey: .user_profile_pic)
        total_rating = try values.decodeIfPresent(String.self, forKey: .total_rating)
        total_driver_ride = try values.decodeIfPresent(String.self, forKey: .total_driver_ride)
        latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        mobile = try values.decodeIfPresent(String.self, forKey: .mobile)
        feedback = try values.decodeIfPresent(String.self, forKey: .feedback)
        total_time = try values.decodeIfPresent(String.self, forKey: .total_time)
        total_distance = try values.decodeIfPresent(String.self, forKey: .total_distance)
        total_arrival_distance = try values.decodeIfPresent(String.self, forKey: .total_arrival_distance)
        total_arrival_time = try values.decodeIfPresent(String.self, forKey: .total_arrival_time)
        cancellation_charge = try values.decodeIfPresent(String.self, forKey: .cancellation_charge)
    }

}
typealias lastRideModalData = LastRideModal
