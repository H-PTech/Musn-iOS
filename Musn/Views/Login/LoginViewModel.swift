//
//  LoginViewModel.swift
//  Musn
//
//  Created by 권민재 on 1/3/25.
//
import SwiftUI
import Combine
import Moya
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
class LoginViewModel: ObservableObject {
    private let provider = MoyaProvider<UserAPI>()
    @Published var isLogin: Bool = false
    @Published var errorMessage: String? = nil
    
    
    private func loginWithKakaoTalk() async throws {
        
        let token: String = try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = oauthToken?.accessToken {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "KakaoLogin", code: -1, userInfo: nil))
                }
            }
        }
        
        //try await sendTokenToServer(token: token)
    }
    
    private func loginWithKakaoAccount() async throws {
        let token: String = try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = oauthToken?.accessToken {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: NSError(domain: "kakaoLogin", code: -1, userInfo: nil))
                }
            }
        }
    }
    
    private func sendTokenToKakao(token: String) async throws {
        do {
            let response = try await provider.asyncRequest(.kakaoLogin(accessToken: token))
            let responseData = try JSONDecoder().decode(LoginResponse.self, from: response.data)
            
        }
    }
    
    
    

}

extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
