//
//  MyPage.swift
//  Musn
//
//  Created by 권민재 on 12/28/24.
//
import Moya
import Foundation

enum MyPageAPI {
    case userInfo(accessToken: String)
    case changeNickName(accessToken: String, nickName: String)
    case fetchDrop(accessToken: String)
}
