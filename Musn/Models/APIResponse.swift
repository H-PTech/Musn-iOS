//
//  APIResponse.swift
//  Musn
//
//  Created by 권민재 on 1/5/25.
//

import Foundation
import Moya

enum NetworkError: Error {
    case invalidResponse
    case statusCode(Int)
    case decodingError
    case moyaError(MoyaError)
}



struct APIResponse<T> {
    let statusCode: String
    let data: T
    let message: String
}
