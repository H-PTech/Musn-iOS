//
//  Token.swift
//  Musn
//
//  Created by 권민재 on 1/6/25.
//

import Foundation

struct Token: Decodable {
    let accessToken: String
    let refreshToken: String
}
