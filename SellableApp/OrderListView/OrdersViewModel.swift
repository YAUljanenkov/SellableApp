//
//  OrdersViewModel.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 18.05.2023.
//

import Foundation
import Combine
class OrdersViewModel: ObservableObject {
    
    @Published var orders =  [OrderResponse]()
    @Published var loadingError: String = ""
    @Published var showAlert: Bool = false

    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ServiceProtocol
    
    init( dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getChatList()
    }
    
    func getChatList() {
        dataManager.fetchOrders()
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.orders = dataResponse.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func createAlert( with error: NetworkError ) {
        loadingError = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
        self.showAlert = true
    }
}
