//
//  OrderResponse.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 16.05.2023.
//

import Foundation

struct OrderResponse: Codable {
    var id: String
    var amount: Int32
    var comment: String?
    var extra: Extra?
    var status: Status?
    var expirationDate: String?
    var qr: QrId
    var receiptNumber: String?
  }


struct Extra: Codable {
    var apiClient: String?
    var apiClientVersion: String?
}

struct Status: Codable {
    var value: String?
    var date: String?
}
