//
//  MapView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//
import SwiftUI
import NMapsMap
import CoreLocation

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    let initialLocation = NMGLatLng(lat: 37.498095, lng: 127.027610)

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.positionMode = .normal
        mapView.isNightModeEnabled = true
        mapView.mapType = .navi

        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation, zoomTo: 14)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        // 초기 마커 추가
        let initialMarker = NMFMarker()
        initialMarker.position = initialLocation
        initialMarker.captionText = "강남역"
        initialMarker.mapView = mapView

        // 사용자 위치 마커 추가
        let userMarker = NMFMarker()
        userMarker.iconImage = NMFOverlayImage(name: "pin", in: .main)
        userMarker.captionText = "내 위치"
        userMarker.mapView = mapView

        // 원형 오버레이 추가
        let circleOverlay = NMFCircleOverlay()
        circleOverlay.center = initialLocation
        circleOverlay.radius = 600
        circleOverlay.fillColor = UIColor.systemGreen.withAlphaComponent(0.2)
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = UIColor.systemGreen.withAlphaComponent(0.4)
        circleOverlay.mapView = mapView

        // 위치 업데이트 클로저 설정
        locationManager.onLocationUpdate = { location in
            let userLocation = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)

            userMarker.position = userLocation
            circleOverlay.center = userLocation

            // 사용자 위치로 카메라 이동
            let userCameraUpdate = NMFCameraUpdate(scrollTo: userLocation, zoomTo: 14)
            userCameraUpdate.animation = .easeIn
            mapView.moveCamera(userCameraUpdate)
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {}
}

struct MapContainerView: View {
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            MapView(locationManager: locationManager)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                HStack {
                    Spacer()

                    // 내 위치로 이동하는 버튼
                    Button(action: {
                        if let userLocation = locationManager.location {
                            locationManager.onLocationUpdate?(userLocation)
                        }
                    }) {
                        Image("mylocation")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: .gray.opacity(0.4), radius: 5, x: 0, y: 3)
                    }
                    .padding(.trailing, 16)
                }
                .padding(.bottom, 25)

               
            }
        }
    }
}
