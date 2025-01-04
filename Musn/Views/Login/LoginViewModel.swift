//
//  LoginViewModel.swift
//  Musn
//
//  Created by 권민재 on 1/3/25.
//
import SwiftUI
import Combine
import Moya
import KakaoSDKAuth
import KakaoSDKUser

@MainActor
class LoginViewModel: ObservableObject {
    private let provider = MoyaProvider<UserAPI>()
    @Published var isLogin: Bool = false
    @Published var errorMessage: String? = nil

    /// 카카오톡 설치 여부를 확인하고, 적절한 로그인 방식을 선택하여 실행
    func loginWithKakao() async {
        do {
            let token: String

            if UserApi.isKakaoTalkLoginAvailable() {
                // 카카오톡 로그인
                token = try await withCheckedThrowingContinuation { continuation in
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
            } else {
                // 카카오 계정 로그인
                token = try await withCheckedThrowingContinuation { continuation in
                    UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let token = oauthToken?.accessToken {
                            continuation.resume(returning: token)
                        } else {
                            continuation.resume(throwing: NSError(domain: "KakaoLogin", code: -1, userInfo: nil))
                        }
                    }
                }
            }

            // 서버로 액세스 토큰 전송
            try await kakaoLogin(accessToken: token)

        } catch {
            errorMessage = "카카오 로그인 실패: \(error.localizedDescription)"
        }
    }

    /// 서버로 카카오 액세스 토큰 전송
    private func kakaoLogin(accessToken: String) async throws {
        let response = try await provider.asyncRequest(.kakaoLogin(accessToken: accessToken))
        guard (200...299).contains(response.statusCode) else {
            throw NSError(domain: "ServerError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "서버 응답 실패: \(response.statusCode)"])
        }

        let responseData = try JSONDecoder().decode(LoginResponse.self, from: response.data)
        print("카카오 로그인 서버 응답 성공: \(responseData)")
        isLogin = true
    }
}

// MARK: - Moya 비동기 확장
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
