//
//  HomeView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        MapContainerView()
            .navigationTitle(locationManager.currentAddress)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

// 버튼 데이터 모델


#Preview {
    HomeView()
}
