//
//  ProfileDM.swift
//  Ocory
//
//  Created by Arun Singh on 02/03/21.
//

import Foundation
import UIKit

// MARK: - Welcome
struct ProfileData: Codable {
    let userID, name, email, country_code, mobile: String?
    let country, state, city: String?
    let profilePic: String?
    let identification_document_id : String?
    let verification_id : String?

    let profileImage: String?
    let vehicleDetail: [String]
    let identification_expiry_date: String?

    let identification_issue_date: String?

//    let profileImage: String?
//    let profileImage: String?
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case country_code = "country_code"
        case name, email, mobile, country, state, city
        case profilePic = "profile_pic"
        case profileImage = "profile_image"
        case vehicleDetail = "vehicle_detail"
        case identification_document_id = "identification_document_id"
        case identification_expiry_date = "identification_expiry_date"
        case identification_issue_date = "identification_issue_date"

        case verification_id = "verification_id"

//        case vehicleDetail = "vehicle_detail"
//        case vehicleDetail = "vehicle_detail"
        
    }
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
