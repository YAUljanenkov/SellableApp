//
//  OrderListView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 18.05.2023.
//

import SwiftUI

struct OrderListView: View {
    
    @ObservedObject var viewModel = OrdersViewModel()
//    @State private var orderList = [OrderResponse(id: "asd", amount: 123, comment: "Lorem ipsum dolor set amet cutum sanctum imis abobus", qr: QrId(id: "adads"), last_time_update: "2023-05-18T13:15:41.057Z")]
    
    var body: some View {
        NavigationStack {
            List(viewModel.orders) { order in
                NavigationLink {
                    OrderView(order: order)
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(String(describing: order.amount))₽")
                            .bold()
                        Text(convertDate(date: order.last_time_update))
                    }
                }
            }
            .navigationTitle("Cписок платежей")
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text (viewModel.loadingError ), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func convertDate(date: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        let oldDate = dateFormatter.date(from: date)
        guard let oldDate = oldDate else { return "Error" }
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return convertDateFormatter.string(from: oldDate)
        
    }
}

struct OrderList_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
