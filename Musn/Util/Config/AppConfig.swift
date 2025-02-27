//
//  AppConfig.swift
//  Musn
//
//  Created by 권민재 on 12/23/24.
//

struct AppConfig {
    
    @InfoPlist("NaverClientSecret")
    static var naverClientSecret: String?
    
    @InfoPlist("NaverClientId")
    static var naverClientId: String?
    
    @InfoPlist("KAKAO_APP_KEY")
    static var kakaoAppKey: String?
    
    @InfoPlist("GIDClientID")
    static var googleKey: String?
    
}
