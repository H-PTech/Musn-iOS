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
    @Published var errorMessage: String? = nil

    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("refreshToken") var refreshToken: String?

    // 카카오 로그인
    func loginWithKakao() async {
        do {
            let token = try await initiateKakaoLogin()
            try await authenticateWithServer(accessToken: token)
        } catch {
            handleError(error, message: "카카오 로그인 실패")
        }
    }

    func validateRefreshToken() async {
        guard let token = refreshToken else {
            print("Refresh Token 없음 - 로그아웃 처리")
            logout()
            return
        }
        
        do {
            print("Refresh Token 유효성 검사 중...")
            let response = try await provider.asyncRequest(.reissueToken(refreshToken: token))
            try validateResponse(response)
            
            let tokenResponse = try decodeResponse(Token.self, from: response.data)
            storeToken(tokenResponse)
            print("Refresh Token 유효 - 새로운 Access Token 발급 성공: \(tokenResponse)")
            isLogin = true
        } catch {
            print("Refresh Token 유효성 검사 실패: \(error.localizedDescription)")
            logout()
        }
    }

    //재발급
    func reissueToken() async {
        guard let token = refreshToken else {
            print("Refresh Token 없음 - 로그아웃 상태로 전환")
            logout()
            return
        }

        do {
            print("Refresh Token으로 Access Token 재발급 중...")
            let response = try await provider.asyncRequest(.reissueToken(refreshToken: token))
            try validateResponse(response)

            let tokenResponse = try decodeResponse(Token.self, from: response.data)
            storeToken(tokenResponse)
            print("토큰 재발급 성공: \(tokenResponse)")
            isLogin = true
        } catch {
            print("토큰 재발급 실패: \(error.localizedDescription)")
            logout()
        }
    }

    // 로그아웃 처리
    func logout() {
        accessToken = nil
        refreshToken = nil
        isLogin = false
        print("로그아웃 완료 - 상태 초기화")
    }

    // 카카오 로그인 플로우 시작
    private func initiateKakaoLogin() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                print("카카오톡 로그인 시도 중...")
                UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                    self.handleOAuthResponse(oauthToken, error, continuation: continuation)
                }
            } else {
                print("카카오 계정 로그인 시도 중...")
                UserApi.shared.loginWithKakaoAccount { oauthToken, error in
                    self.handleOAuthResponse(oauthToken, error, continuation: continuation)
                }
            }
        }
    }

    // 서버로 Access Token 전송
    private func authenticateWithServer(accessToken: String) async throws {
        let response = try await provider.asyncRequest(.kakaoLogin(accessToken: accessToken))
        try validateResponse(response)

        let tokenResponse = try decodeResponse(Token.self, from: response.data)
        storeToken(tokenResponse)
        print("서버 인증 성공: \(tokenResponse)")
        isLogin = true
    }

    // 서버 응답 상태 검증
    private func validateResponse(_ response: Response) throws {
        guard (200...299).contains(response.statusCode) else {
            throw NSError(domain: "ServerError", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "서버 응답 실패: \(response.statusCode)"])
        }
    }

    // JSON 디코딩
    private func decodeResponse<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "JSON 디코딩 실패: \(error.localizedDescription)"])
        }
    }

    // OAuth 응답 처리
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
        accessToken = tokenResponse.accessToken
        refreshToken = tokenResponse.refreshToken
        print("토큰 저장 완료: AccessToken=\(tokenResponse.accessToken), RefreshToken=\(tokenResponse.refreshToken)")
    }

    // 오류 처리
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        print("Error: \(message): \(error)")
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
