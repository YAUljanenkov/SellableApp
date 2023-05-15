//
//  NetworkError.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 15.05.2023.
//

import Foundation
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}
