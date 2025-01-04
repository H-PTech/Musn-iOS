//
//  LoginResponse.swift
//  Musn
//
//  Created by 권민재 on 1/3/25.
//
import Foundation

struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let id: Int
    let nickname: String
    let streamingApp: String
    let isPush: Bool
}
