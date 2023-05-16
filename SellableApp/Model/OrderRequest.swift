//
//  OrderRequest.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 16.05.2023.
//

import Foundation

struct OrderRequest: Codable {
    var amount: Int32
    var comment: String
    var qr: QrId
}

struct QrId: Codable {
    var id: String
    var additionalInfo: String?
    var paymentDetails: String?
}
