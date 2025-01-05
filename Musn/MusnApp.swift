//
//  MusnApp.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI
import NMapsMap
import FirebaseCore
import KakaoSDKCommon
import GoogleSignIn
import KakaoSDKAuth


class AppDelegate: NSObject, UIApplicationDelegate {
    
    var googleSignInConfig: GIDConfiguration?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        googleSignInConfig = GIDConfiguration(clientID: AppConfig.googleKey ?? "")
        
        return true
    }
}

@main
struct MusnApp: App {
    
    @StateObject private var loginViewModel = LoginViewModel()
    
    init() {
        if let clientId = Bundle.main.object(forInfoDictionaryKey: "NaverClientID") as? String {
            NMFAuthManager.shared().clientId = clientId
            print("Naver Client ID 설정: \(clientId)")
        } else {
            fatalError("NaverClientID not found in Info.plist")
        }
        KakaoSDK.initSDK(appKey: AppConfig.kakaoAppKey ?? "")
    }
    var body: some Scene {
        WindowGroup {
            if Settings.accessToken != nil {
                ContentView()
                    .preferredColorScheme(.dark)
            } else {
                LoginView()
                    .onOpenURL { url in
                        if AuthApi.isKakaoTalkLoginUrl(url) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
            }
        }
    }
}
