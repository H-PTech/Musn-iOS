//
//  UserAPI.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//
import Foundation
import Moya


enum UserAPI {
    case login(accessToken: String)
    //case logout
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://musn.shop/v1")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let accessToken):
            return .requestParameters(parameters: ["token": accessToken], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login(_):
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
