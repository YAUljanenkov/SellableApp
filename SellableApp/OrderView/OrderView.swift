//
//  OrderView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 18.05.2023.
//

import SwiftUI

struct OrderView: View {
    let order: OrderResponse
    
    var body: some View {
        List {
            HStack {
                Text("сумма")
                    .bold()
                Spacer()
                Text("\(String(describing: order.amount))₽")
            }.padding(5)
            HStack {
                Text("Дата")
                    .bold()
                Spacer()
                Text(convertDate(date: order.last_time_update))
            }.padding(5)
            HStack {
                Text("Статус")
                    .bold()
                Spacer()
                Text(order.status?.value ?? "нет")
            }.padding(5)
            HStack {
                Text("ID")
                    .bold()
                Spacer()
                Text(order.id)
            }.padding(5)
            HStack {
                Text("QR ID")
                    .bold()
                Spacer()
                Text(order.qr.id)
            }.padding(5)
        }.navigationTitle("Платёж")
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

//struct OrderView_Previews: PreviewProvider {
//    static var previews: some View {
//        OrderView()
//    }
//}
