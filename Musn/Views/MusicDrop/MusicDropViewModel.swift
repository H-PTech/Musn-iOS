//
//  MusicDropViewModel.swift
//  Musn
//
//  Created by 권민재 on 1/30/25.
//

import Foundation
import Moya

class MusicDropViewModel {
    
    private let provider = MoyaProvider<DropAPI>()
    
    func fetchAllDrops(lat: Double, lng: Double, radius: Double? = nil) async throws -> [Drop] {
        do {
            let result = try await provider.asyncRequest(.fetchAllDrop(lat: lat, lng: lng, radius: radius))
            
            guard (200...299).contains(result.statusCode) else {
                throw NetworkError.statusCode(result.statusCode)
            }
            
            return try JSONDecoder().decode([Drop].self, from: result.data)
            
        } catch let moyaError as MoyaError {
            throw NetworkError.moyaError(moyaError)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func addDrop(
            accessToken: String,
            lng: Double,
            lat: Double,
            category: String?,
            content: String,
            type: Int,
            code: String?,
            title: String?,
            url: String?
        ) async throws {
            do {
                let result = try await provider.asyncRequest(
                    .addDrop(
                        accessToken: accessToken,
                        lng: lng,
                        lat: lat,
                        category: category,
                        content: content,
                        type: type,
                        code: code,
                        title: title,
                        url: url
                    )
                )
                
                guard (200...299).contains(result.statusCode) else {
                    throw NetworkError.statusCode(result.statusCode)
                }
                
                return
                
            } catch let moyaError as MoyaError {
                throw NetworkError.moyaError(moyaError)
            } catch {
                throw NetworkError.decodingError
            }
        }
    
    
}
