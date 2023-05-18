//
//  MainView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 18.05.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ScannerView()
                .tabItem {
                    Label("Сканнер", systemImage: "qrcode")
                }
            OrderListView()
                .tabItem {
                    Label("Платежи", systemImage: "tray.full")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
