//
//  OrderListView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 18.05.2023.
//

import SwiftUI

struct OrderListView: View {
    
    @State private var orderList = [OrderResponse(id: "asd", amount: 123, qr: QrId(id: "adads"), last_time_update: "2023-05-18T13:15:41.057Z")]
    
    var body: some View {
        NavigationStack {
            List(orderList) { order in
                NavigationLink {
                    OrderView(order: order)
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(String(describing: order.amount))₽")
                            .bold()
                        Text(convertDate(date: order.last_time_update))
                    }
                }
            }.navigationTitle("Cписок платежей")
        }
    }
    
    func convertDate(date: String?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        let oldDate = dateFormatter.date(from: date)
        guard let oldDate = oldDate else { return "" }
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
