//
//  CardDM.swift
//  Ocory
//
//  Created by nile on 21/09/21.
//

import Foundation
// MARK: - WelcomeElement


struct cardDataModal: Codable {
    var card_type, card_number, card_holder_name, bank_name,customer_id,expiry_date,expiry_month,id: String?
    let is_default : String?
}
typealias userCardData = [cardDataModal]



