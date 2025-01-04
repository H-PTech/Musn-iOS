//
//  AppState.swift
//  Musn
//
//  Created by 권민재 on 1/4/25.
//
import Combine

class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var accessToken: String? = nil
    @Published var refreshToken: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
}
