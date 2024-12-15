//
//  MapView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//

import SwiftUI
import NMapsMap

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.positionMode = .normal
        mapView.isNightModeEnabled = true
        mapView.mapType = .basic
        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
       
    }
}
