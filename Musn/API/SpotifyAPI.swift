//
//  SpotifyA{PI.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//

import Foundation
import Moya

enum SpotifyAPI {
    case searchMusic(query: String, accessToken: String)
}

extension SpotifyAPI: TargetType {
    
    var baseURL: URL { URL(string: "https://api.spotify.com/v1")! }
    var path: String {
        switch self {
        case .searchMusic:
            return "/search"
        }
    }
    
    var method: Moya.Method { .get }
    
    var task: Task {
           switch self {
           case .searchMusic(let query, let accessToken):
               return .requestParameters(
                   parameters: ["q": query, "type": "track", "limit": 10],
                   encoding: URLEncoding.queryString
               )
           }
       }
       var headers: [String: String]? {
           switch self {
           case .searchMusic(_, let accessToken):
               return ["Authorization": "Bearer \(accessToken)"]
           }
       }
}
