//
//  SpotifyA{PI.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//

import Foundation
import Moya


class SpotifyAPI {
    private let clientID = "YOUR_CLIENT_ID"
    private let clientSecret = "YOUR_CLIENT_SECRET"
    private let tokenURL = "https://accounts.spotify.com/api/token"
    private var accessToken: String = ""
    
    // MARK: - Access Token 요청
    func requestAccessToken(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: tokenURL) else { return }
        
        let credentials = "\(clientID):\(clientSecret)"
        guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let token = json["access_token"] as? String {
                    self.accessToken = token
                    print("Access Token: \(token)")
                    completion(true)
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion(false)
            }
        }.resume()
    }
    
    // MARK: - 검색 API 호출
    func searchTrack(query: String, completion: @escaping ([String]) -> Void) {
        let searchURL = "https://api.spotify.com/v1/search?q=\(query)&type=track"
        guard let url = URL(string: searchURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let tracks = json["tracks"] as? [String: Any],
                   let items = tracks["items"] as? [[String: Any]] {
                    let trackNames = items.compactMap { $0["name"] as? String }
                    completion(trackNames)
                } else {
                    completion([])
                }
            } catch {
                print("JSON Parsing Error: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}
