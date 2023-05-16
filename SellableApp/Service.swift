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
    func fetchQrData(qrId: String) -> AnyPublisher<DataResponse<QrCode, NetworkError>, Never>
    func createOrder(data: OrderRequest) -> AnyPublisher<DataResponse<OrderResponse, NetworkError>, Never>
    func fetchQrOrder(qrId: String) -> AnyPublisher<DataResponse<OrderResponse, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func fetchQrData(qrId: String) -> AnyPublisher<DataResponse<QrCode, NetworkError>, Never> {
        let url = URL(string: "http://\(Config.ip):\(Config.port)/qr/\(qrId)")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: QrCode.self)
            .map { response in
                return response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchQrOrder(qrId: String) -> AnyPublisher<DataResponse<OrderResponse, NetworkError>, Never> {
        let url = URL(string: "http://\(Config.ip):\(Config.port)/qr/order/\(qrId)")!
        
        return AF.request(url, method: .get)
            .validate()
            .publishDecodable(type: OrderResponse.self)
            .map { response in
                return response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func createOrder(data: OrderRequest) -> AnyPublisher<DataResponse<OrderResponse, NetworkError>, Never> {
        let url = URL(string: "http://\(Config.ip):\(Config.port)/order/create")!
        let headers: HTTPHeaders = ["Authorization": Config.token]
        return AF.request(url, method: .post, parameters: data, encoder: JSONParameterEncoder.default, headers: headers).validate()
            .publishDecodable(type: OrderResponse.self)
            .map { response in
                return response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
