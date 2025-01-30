//
//  MapView.swift
//  Musn
//
//  Created by 권민재 on 12/15/24.
//
import SwiftUI
import NMapsMap
import CoreLocation
import Kingfisher


extension UIImage {
    func circularImage() -> UIImage? {
        let square = min(size.width, size.height)
        let rect = CGRect(x: (size.width - square) / 2, y: (size.height - square) / 2, width: square, height: square)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: square, height: square), false, scale)
        let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: CGSize(width: square, height: square)))
        path.addClip()
        draw(in: CGRect(origin: CGPoint(x: -rect.origin.x, y: -rect.origin.y), size: size))
        let circularImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return circularImage
    }
    func resizedImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    let initialLocation = NMGLatLng(lat: 37.498095, lng: 127.027610)

    @Binding var markers: [DropMarker]
    private let infoWindow = NMFInfoWindow()

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView(frame: .zero)
        mapView.positionMode = .normal
        mapView.isNightModeEnabled = true
        mapView.mapType = .navi

     
        let cameraUpdate = NMFCameraUpdate(scrollTo: initialLocation, zoomTo: 14)
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)

        
        let circleOverlay = NMFCircleOverlay()
        circleOverlay.center = initialLocation
        circleOverlay.radius = 600
        circleOverlay.fillColor = UIColor.systemGreen.withAlphaComponent(0.2)
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = UIColor.systemGreen.withAlphaComponent(0.4)
        circleOverlay.mapView = mapView

        locationManager.onLocationUpdate = { location in
            let userLocation = NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
            circleOverlay.center = userLocation

            let userCameraUpdate = NMFCameraUpdate(scrollTo: userLocation, zoomTo: 14)
            userCameraUpdate.animation = .easeIn
            mapView.moveCamera(userCameraUpdate)
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
       
        let circleOverlay = NMFCircleOverlay()
        circleOverlay.center = initialLocation
        circleOverlay.radius = 600
        circleOverlay.fillColor = UIColor.systemGreen.withAlphaComponent(0.1) // 내부 색상 투명도
        circleOverlay.outlineWidth = 1
        circleOverlay.outlineColor = UIColor.systemGreen.withAlphaComponent(0.4) // 테두리 색상 투명도
        circleOverlay.mapView = uiView

        
        //MARK: marker add
        markers.forEach { markerData in
            let marker = NMFMarker(position: NMGLatLng(lat: markerData.latitude, lng: markerData.longitude))

            if let imageURL = URL(string: markerData.imageURL) {
                let targetSize = CGSize(width: 40, height: 40)

                KingfisherManager.shared.retrieveImage(with: imageURL) { result in
                    switch result {
                    case .success(let value):
                    
                        if let resizedImage = value.image.resizedImage(to: targetSize),
                           let circularImage = resizedImage.circularImage() {
                            marker.iconImage = NMFOverlayImage(image: circularImage)
                        } else {
                            marker.iconImage = NMFOverlayImage(image: value.image)
                        }
                    case .failure(let error):
                        print("Kingfisher 이미지 로드 실패: \(error.localizedDescription)")
                        marker.iconImage = NMFOverlayImage(image: UIImage(named: "default_pin")!)
                    }
                }
            }

            
            marker.touchHandler = { overlay in
                let dataSource = NMFInfoWindowDefaultTextSource.data()
                dataSource.title = markerData.title
                self.infoWindow.dataSource = dataSource
                self.infoWindow.open(with: marker)
                return true
            }

            marker.mapView = uiView
        }
    }
}

struct MapContainerView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var markers: [DropMarker] = [
           
       ]

    var body: some View {
        ZStack {
            MapView(locationManager: locationManager, markers: $markers)
                .edgesIgnoringSafeArea(.all)

            // 추가 UI 요소 (필요한 경우만)
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








#Preview {
    MapContainerView()
}
