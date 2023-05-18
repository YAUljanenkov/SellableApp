//
//  SellableApp.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 13.05.2023.
//

import SwiftUI
import SDWebImageSVGCoder

@main
struct SellableApp: App {
    
    init() {
        setUpDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
//            QrView(qrId: "AS7F126E74B844FBA9584BE6A5B27B42")
        }
    }
}

private extension SellableApp {
    func setUpDependencies() {
        SDImageCodersManager.shared.addCoder(SDImageSVGCoder.shared)
    }
}
