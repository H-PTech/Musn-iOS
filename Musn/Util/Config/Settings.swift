//
//  Settings.swift
//  Musn
//
//  Created by 권민재 on 1/2/25.
//

struct Settings {
    @UserDefault(key: "accessToken", defaultValue: nil)
    static var accessToken: String?
    
    @UserDefault(key: "refreshToken", defaultValue: nil)
    static var refreshToken: String?
    
}
