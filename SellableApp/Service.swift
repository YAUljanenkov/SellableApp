//
//  Service.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 15.05.2023.
//

import Foundation
import Combine
import Alamofire

protocol ServiceProtocol {
    func fetchQrDAta(qrId: String) -> AnyPublisher<DataResponse<QrCode, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchQrDAta(qrId: String) -> AnyPublisher<DataResponse<QrCode, NetworkError>, Never> {
        let url = URL(string: "http://158.160.29.31:8000/qr/\(qrId)")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: QrCode.self)
            .map { response in
                print(response)
                return response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
