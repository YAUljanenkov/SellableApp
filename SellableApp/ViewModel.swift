//
//  ViewModel.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 15.05.2023.
//

import Foundation
import Combine
class ViewModel: ObservableObject {
    
    @Published var qr: QrCode?
    @Published var chatListLoadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    private var qrId: String
    
    init( dataManager: ServiceProtocol = Service.shared, qrId: String) {
        self.dataManager = dataManager
        self.qrId = qrId
        getQrData()
    }
    
    func getQrData() {
        dataManager.fetchQrDAta(qrId: self.qrId)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.qr = dataResponse.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError ) {
        chatListLoadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
