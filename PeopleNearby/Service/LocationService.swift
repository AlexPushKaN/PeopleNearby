//
//  LocationManager.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation
import CoreLocation

enum LocationError: Error {
    case accessDenied
    case unknown
}

final class LocationService: NSObject {
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    private var onAuthorizationGranted: ((Result<Void, LocationError>) -> Void)?
    
    var getCurrentLocation: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    
    private override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
    }
    
    func requestLocationAccess(completion: @escaping (Result<Void, LocationError>) -> Void) {
        onAuthorizationGranted = { [weak self] result in
            if case .success = result {
                completion(.success(()))
            } else {
                completion(.failure(.accessDenied))
            }
            self?.onAuthorizationGranted = nil
        }
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getCurrentLocation?(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        onLocationError?(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            onAuthorizationGranted?(.success(()))
        case .denied, .restricted:
            onAuthorizationGranted?(.failure(.accessDenied))
        default:
            break
        }
    }
}
