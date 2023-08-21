//
//  HomeModal.swift
//  Ocory
//
//  Created by nile on 26/08/21.
//

import Foundation
// MARK: - Body
struct CustomerModal: Codable {
    let  driver_fcm,driver_name,user_fcm,user_name,count_cancelled_ride,pickup_lat,pickup_long,drop_lat,drop_long,ride_id,distance,vehicle_type_id,ride_status,cancelled_count,driver_id,email,amount,drop_address,pickup_adress : String?
    let mobile,total_arrival_distance,total_arrival_time,total_rating,total_time,total_distance,status,profile_pic : String?
    let cancellation_charge : String?
}

typealias userCustomerModal = CustomerModal


