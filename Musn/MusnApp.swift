//
//  MusnApp.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI
import NMapsMap

@main
struct MusnApp: App {
    
    init() {
        if let clientId = Bundle.main.object(forInfoDictionaryKey: "NaverClientID") as? String {
            NMFAuthManager.shared().clientId = clientId
            print("Naver Client ID 설정: \(clientId)")
        } else {
            fatalError("NaverClientID not found in Info.plist")
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
