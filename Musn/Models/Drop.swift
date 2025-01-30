//
//  Drop.swift
//  Musn
//
//  Created by 권민재 on 1/30/25.
//

struct Drop: Codable {
    let id: Int
    let content: String
    let userId: Int
    let category: String
    let lat: Double
    let lng: Double
    let views: Int
    let likeCount: Int
    let type: Int
    let code: String
    let title: String
    let url: String
}
