//
//  LocationManager.swift
//  Musn
//
//  Created by 권민재 on 12/16/24.
//
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var currentAddress: String = "Fetching..."
    @Published var location: CLLocation?
    @Published var error: Error?
    
    var onLocationUpdate: ((CLLocation) -> Void)?

    private var isOneTimeUpdate: Bool
    
    init(isOneTimeUpdate: Bool = true, accuracy: CLLocationAccuracy = kCLLocationAccuracyBest) {
        self.isOneTimeUpdate = isOneTimeUpdate
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = accuracy
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func fetchAddress(from location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    self.currentAddress = "\(placemark.subLocality ?? "Unknown") \(placemark.thoroughfare ?? "Unknown") 🎧"
                }
            } else {
                self.currentAddress = "Address unavailable"
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        self.location = newLocation
        fetchAddress(from: newLocation)
        
        onLocationUpdate?(newLocation)
        
        if isOneTimeUpdate {
            manager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        self.currentAddress = "Location error"
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
