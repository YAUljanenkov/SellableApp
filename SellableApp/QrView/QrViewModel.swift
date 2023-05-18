//
//  ViewModel.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 15.05.2023.
//

import Foundation
import Combine

struct Order {
    var amount: String
    var comment: String
    var qrId: String
}

class QrViewModel: ObservableObject {
    
    @Published var qr: QrCode
    @Published var order: Order
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false
    @Published var showToast: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    private var qrId: String
    private var orderResponse: OrderResponse?
    
    init( dataManager: ServiceProtocol = Service.shared, qrId: String) {
        self.dataManager = dataManager
        self.qrId = qrId
        self.order = Order(amount: "", comment: "", qrId: qrId)
        self.qr = QrCode(qrId: "", payload: "", qrUrl: "")
        getQrData()
        getOrderData()
    }
    
    func getQrData() {
        dataManager.fetchQrData(qrId: self.qrId)
            .sink { [weak self] (dataResponse) in
                if dataResponse.error != nil {
                    self?.createAlert(with: dataResponse.error!)
                } else {
                    self?.qr = dataResponse.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func getOrderData() {
        dataManager.fetchQrOrder(qrId: self.qrId)
            .sink { [weak self] (dataResponse) in
                if dataResponse.error != nil {
                    if dataResponse.error?.backendError?.status != "404" {
                        self?.createAlert(with: dataResponse.error!)
                    }
                } else {
                    self?.orderResponse = dataResponse.value!
                    self?.order.amount = String(describing: self?.orderResponse?.amount)
                    self?.order.comment = self?.orderResponse?.comment ?? ""
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError ) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
    
    func createOrder() {
        let data = OrderRequest(amount: Int32(order.amount) ?? 0, comment: order.comment, qr: QrId(id: order.qrId))
        dataManager.createOrder(data: data)
            .sink {[weak self] (dataResponse) in
                if dataResponse.error != nil {
                    self?.createAlert(with: dataResponse.error!)
                } else {
                    self?.orderResponse = dataResponse.value!
                    self?.order.amount = String(describing: self?.orderResponse?.amount)
                    self?.order.comment = self?.orderResponse?.comment ?? ""
                    self?.showToast = true
                }
            }.store(in: &cancellableSet)
    }
}
