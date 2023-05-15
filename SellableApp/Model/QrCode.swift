//
//  QrCode.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 15.05.2023.
//

import Foundation

struct QrCode: Identifiable, Codable {
    var id: Int?
    var qrId: String
    var qrStatus: String?
    var qrExpirationDate: String?
    var payload: String
    var qrUrl: String
    var subscriptionId: String?
}
