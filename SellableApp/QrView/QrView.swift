//
//  QrView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 13.05.2023.
//

import SwiftUI
import Combine
import SDWebImageSwiftUI
import AlertToast

struct QrView: View {
    var qrId: String
    

    @ObservedObject var viewModel: QrViewModel
    
    init(qrId: String) {
        self.qrId = qrId
        viewModel = QrViewModel(qrId: qrId)
    }
    
    func activate() {
        viewModel.createOrder()
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(viewModel.qr.qrId)
                WebImage(url: URL(string: "https://test.ecom.raiffeisen.ru/api/sbp/v2/qr/AS7F126E74B844FBA9584BE6A5B27B42/image"), options: [], context: [.imageThumbnailPixelSize : CGSize.zero])
                    .placeholder {ProgressView()}
                    .resizable()
                    .background { Color.white }
                    .frame(width: 200, height: 200)
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
            .toast(isPresenting: $viewModel.showToast) {
                AlertToast(type: .complete(.gray), title: "Заказ создан!")
            }
        }.onTapGesture {
            hideKeyboard()
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

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct QrView_Previews: PreviewProvider {
    static var previews: some View {
        QrView(qrId: "AS7F126E74B844FBA9584BE6A5B27B42")
    }
}
