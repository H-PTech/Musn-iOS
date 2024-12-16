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
    @StateObject private var locationManager = LocationManager()
    let initialLocation = NMGLatLng(lat: 37.498095, lng: 127.027610) // 강남역 좌표

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.positionMode = .normal
        mapView.isNightModeEnabled = true
        mapView.mapType = .navi

        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation, zoomTo: 15)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

      
        let initialMarker = NMFMarker()
        initialMarker.position = initialLocation
        initialMarker.captionText = "강남역"
        initialMarker.mapView = mapView

        
        let userMarker = NMFMarker()
        userMarker.iconImage = NMFOverlayImage(name: "pin", in: .main)
        userMarker.captionText = "내 위치"
        userMarker.mapView = mapView

        
        let circleOverlay = NMFCircleOverlay()
        circleOverlay.center = initialLocation
        circleOverlay.radius = 200
        circleOverlay.fillColor = UIColor.systemGreen.withAlphaComponent(0.2)
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = UIColor.systemGreen.withAlphaComponent(0.4)
        circleOverlay.mapView = mapView

        
        locationManager.onLocationUpdate = { location in
            let userLocation = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)

          
            userMarker.position = userLocation
            circleOverlay.center = userLocation

            
            let userCameraUpdate = NMFCameraUpdate(scrollTo: userLocation)
            userCameraUpdate.animation = .easeIn
            mapView.moveCamera(userCameraUpdate)
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {}
}
