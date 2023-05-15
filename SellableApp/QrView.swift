//
//  QrView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 13.05.2023.
//

import SwiftUI
import Combine

struct QrView: View {
    var qrId: String
    
    @State private var amount = ""
    @ObservedObject var viewModel: ViewModel
    
    init(qrId: String) {
        self.qrId = qrId
        viewModel = ViewModel(qrId: qrId)
    }
    
    var body: some View {
        VStack {
            Text(qrId)
            TextField("Сумма платежа", text: $amount).keyboardType(.numberPad)
                .onReceive(Just(amount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.amount = filtered
                    }
                }
        }.navigationTitle("QR код")
    }
}

struct QrView_Previews: PreviewProvider {
    static var previews: some View {
        QrView(qrId: "lol")
    }
}
