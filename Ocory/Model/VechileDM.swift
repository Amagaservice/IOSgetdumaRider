//
//  VechileDM.swift
//  Ocory
//
//  Created by Arun Singh on 05/03/21.
//

import Foundation
// MARK: - WelcomeElement
struct VechileData: Codable {
    let id, title, rate, shortDescription: String?
    let carPic,totalAmount : String?

    enum CodingKeys: String, CodingKey {
        case id, title, rate
        case shortDescription = "short_description"
        case carPic = "car_pic"
        case totalAmount = "total_amount"
    }
}

typealias vechile = [VechileData]
