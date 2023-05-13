//
//  ScannerView.swift
//  SellableApp
//
//  Created by Ярослав Ульяненков on 13.05.2023.
//

import CodeScanner
import SwiftUI

struct ScannerView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            CodeScannerView(codeTypes: [.qr], showViewfinder: true, completion: handleScan)
                .navigationTitle("Скан QR кода")
                .cornerRadius(10.0)
                .navigationDestination(for: String.self) { qr in
                    return QrView(qrId: qr)
                }
        }
        
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        switch result {
            case .success(let result):
            guard let qrId = parseQrString(result.string) else {
                print("Parse failed")
                return
            }
            path.append(qrId)
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func parseQrString(_ data: String) -> String? {
        if data.contains("https://qr.nspk.ru/") {
            return String(data.dropFirst(19).prefix(32)) as String
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
