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

final class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private var onAuthorizationGranted: ((Result<Void, LocationError>) -> Void)?
    var currentLocation: CLLocation? { locationManager.location }
    var onFirstLocationUpdate: ((CLLocation) -> Void)?
    var onLocationError: ((Error) -> Void)?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationAccess(startUpdating: Bool = true, completion: @escaping (Result<Void, LocationError>) -> Void) {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            onAuthorizationGranted = { result in
                if startUpdating, case .success = result {
                    self.startUpdatingLocation()
                }
                completion(result)
            }
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            completion(.success(()))
            if startUpdating { startUpdatingLocation() }
        case .denied, .restricted:
            completion(.failure(.accessDenied))
        @unknown default:
            completion(.failure(.unknown))
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        if let callback = onFirstLocationUpdate {
            callback(location)
            onFirstLocationUpdate = nil
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения локации: \(error.localizedDescription)")
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
        onAuthorizationGranted = nil
    }
}
