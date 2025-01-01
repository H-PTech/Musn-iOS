//
//  DropAPI.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//

import Moya
import Foundation


enum DropAPI {
    case fetchAllDrop(lat: Double, lng: Double, radius: Double?)
    
    
    
    //CRUD
    case addDrop(accessToken: String, lng: Double, lat: Double, category: String?, content: String, type: Int, code: String?, title: String?, url: String?)
    
}

extension DropAPI: TargetType, ParameterBuildable {
    var baseURL: URL {
        return URL(string: "https://musn.shop/v1")!
    }
    
    var path: String {
        switch self {
        case .fetchAllDrop:
            return "drop"
        case .addDrop:
            return "drop"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchAllDrop:
            return .get
        case .addDrop:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchAllDrop(let lat, let lng, let radius):
            let params = buildParameters(
                required: [
                    "lat": lat,
                    "lng": lng
                ],
                optional: [
                    "radius": radius
                ]
            )
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
            
        case .addDrop(_, let lng, let lat, let category, let content, let type, let code, let title, let url):
            let params = buildParameters(
                required: [
                    "lng": lng,
                    "lat": lat,
                    "content": content,
                    "type": type
                ],
                optional: [
                    "category": category,
                    "code": code,
                    "title": title,
                    "url": url
                ]
            )
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchAllDrop:
            return [
                "Content-Type": "application/json"
            ]
        case .addDrop(let accessToken, _, _, _, _, _, _, _, _):
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json"
            ]
        }
    }
    
    
}
