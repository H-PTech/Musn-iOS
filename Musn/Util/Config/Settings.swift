//
//  Settings.swift
//  Musn
//
//  Created by 권민재 on 1/2/25.
//

struct Settings {
    @UserDefault(key: "accessToken", defaultValue: "")
    static var accessToken: String
}
