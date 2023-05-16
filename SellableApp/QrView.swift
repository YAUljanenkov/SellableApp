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
    

    @ObservedObject var viewModel: ViewModel
    
    init(qrId: String) {
        self.qrId = qrId
        viewModel = ViewModel(qrId: qrId)
    }
    
    func activate() {
        viewModel.createOrder()
    }
    
    var body: some View {
        VStack {
            Text(qrId)
            Text(viewModel.order.comment)
            AsyncImage(url: URL(string: viewModel.qr?.qrUrl ?? ""))
            TextField("Сумма платежа", text: $viewModel.order.amount).keyboardType(.numberPad)
                .onReceive(Just(viewModel.order.amount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        viewModel.order.amount = filtered
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Комментарий", text: $viewModel.order.comment, axis: .vertical)
                .lineLimit(5...10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Активировать", action: activate)
                .buttonStyle(GrowingButton())
        }
        .padding(20)
        .navigationTitle("QR код")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text (viewModel.loadingError ), dismissButton: .default(Text("OK")))
        }
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.yellow)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct QrView_Previews: PreviewProvider {
    static var previews: some View {
        QrView(qrId: "AS7F126E74B844FBA9584BE6A5B27B42")
    }
}
