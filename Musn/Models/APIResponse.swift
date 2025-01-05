//
//  APIResponse.swift
//  Musn
//
//  Created by 권민재 on 1/5/25.
//

import Foundation

struct APIResponse<T> {
    let statusCode: String
    let data: T
    let message: String
}
