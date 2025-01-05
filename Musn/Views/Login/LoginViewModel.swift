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
    
    func loginWithKakao() async {
        do {
            let accessToken = try await initiateKakaoLogin()
            try await authenticateWithServer(accessToken: accessToken)
        } catch {
            handleError(error, message: "카카오 로그인 실패")
        }
    }

    func reissueToken() async {
        do {
            guard let refreshToken = Settings.refreshToken else {
                throw NSError(domain: "RefreshTokenError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Refresh token not found."])
            }
            let response = try await provider.asyncRequest(.reissueToken(refreshToken: refreshToken))
            try validateResponse(response)
            
            let tokenResponse = try decodeResponse(Token.self, from: response.data)
            storeToken(tokenResponse)
            print("토큰 재발급 성공")
        } catch {
            handleError(error, message: "토큰 재발급 실패")
        }
    }
    
    private func initiateKakaoLogin() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                print("카카오톡 로그인 시도")
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    self.handleOAuthResponse(oauthToken, error, continuation: continuation)
                }
            } else {
                print("카카오 계정 로그인 시도")
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    self.handleOAuthResponse(oauthToken, error, continuation: continuation)
                }
            }
        }
    }

    private func authenticateWithServer(accessToken: String) async throws {
        let response = try await provider.asyncRequest(.kakaoLogin(accessToken: accessToken))
        try validateResponse(response)
        
        let tokenResponse = try decodeResponse(Token.self, from: response.data)
        storeToken(tokenResponse)
        print("카카오 로그인 서버 응답 성공: \(tokenResponse)")
        
        isLogin = true
    }

    private func validateResponse(_ response: Response) throws {
        guard (200...299).contains(response.statusCode) else {
            throw NSError(domain: "ServerError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "서버 응답 실패: \(response.statusCode)"])
        }
    }

    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON 디코딩 실패: \(error.localizedDescription)"])
        }
    }

    private func handleOAuthResponse(
        _ oauthToken: OAuthToken?,
        _ error: Error?,
        continuation: CheckedContinuation<String, Error>
    ) {
        if let error = error {
            continuation.resume(throwing: error)
        } else if let token = oauthToken?.accessToken {
            continuation.resume(returning: token)
        } else {
            continuation.resume(throwing: NSError(domain: "KakaoLogin", code: -1, userInfo: nil))
        }
    }

    // 토큰 저장
    private func storeToken(_ tokenResponse: Token) {
        Settings.accessToken = tokenResponse.accessToken
        Settings.refreshToken = tokenResponse.refreshToken
    }

    // 오류 처리
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        print("Error: \(error)")
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
