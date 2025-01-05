//
//  UserAPI.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//
import Foundation
import Moya


enum UserAPI {
    case kakaoLogin(accessToken: String)
    case googleLogin(accessToken: String)
    case reissueToken(refreshToken: String)
    case checkValidate(accessToken: String)
   
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://musn.shop/v1")!
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/auth/login/kakao"
        case .googleLogin:
            return "/auth/login/google"
        case .checkValidate:
            return "/auth/validate"
        case .reissueToken:
            return "/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin,.googleLogin,.reissueToken:
            return .post
        case .checkValidate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(_), .googleLogin(_), .checkValidate(_), .reissueToken(_):
            return .requestPlain
        
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .checkValidate(let accessToken), .reissueToken(let accessToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(accessToken)"
            ]
        case .kakaoLogin(let accessToken),.googleLogin(let accessToken):
            return [
                "Content-Type": "application/json",
                "Authorization": "\(accessToken)"
            ]
        }
    }
}
