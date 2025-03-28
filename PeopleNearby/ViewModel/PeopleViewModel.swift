//
//  PeopleViewModel.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation
import CoreLocation

final class PeopleViewModel: PeopleViewModelProtocol {
    private let peopleService: PeopleService
    private let networkService: NetworkServiceProtocol
    private let locationService: LocationService
    
    var onPeopleUpdated: (() -> Void)?
    var currentLocation: CLLocation? = nil {
        didSet {
            guard let currentLocation else { return }
            fetchPeople(nearby: currentLocation) { [weak self] in
                guard let self else { return }
                onPeopleUpdated?()
            }
        }
    }
    var people: [Person] = [] {
        didSet {
            onPeopleUpdated?()
        }
    }
    
    func authorizationStatus() -> CLAuthorizationStatus  {
        locationService.locationManager.authorizationStatus
    }
    
    init(services people: PeopleService, _ network: NetworkServiceProtocol, and locationService: LocationService) {
        self.peopleService = people
        self.networkService = network
        self.locationService = locationService
    }

    func requestLocationAccess(completionHandler completion: @escaping (Result<Void, LocationError>) -> Void) {
        locationService.requestLocationAccess { result in
            completion(result)
        }
    }
    
    func getLocationAndFetchPeople() {
        locationService.getCurrentLocation = { [weak self] location in
            self?.currentLocation = location
        }
        locationService.onLocationError = { locationError in
            print("Ошибка получения локации: \(locationError.localizedDescription)")
        }
        locationService.requestLocation()
    }

    func fetchPeople(nearby location: CLLocation, completionHandler: @escaping () -> Void) {
        peopleService.fetchPeople(nearby: location) { [weak self] newPeople in
            guard let self = self else { return }
            self.people = newPeople
            completionHandler()
        }
    }

    func updatePeopleLocations(except person: Person?) {
        peopleService.updateLocations(for: people, except: person) { [weak self] updatedPeople in
            guard let self = self else { return }
            self.people = updatedPeople
        }
    }
    
    func calculateDistance(from location: CLLocation, to person: Person) -> Double {
        let personLocation = person.getCurrentLocation().toCLLocation()
        return location.distance(from: personLocation) / 1000
    }

    func fetchImageData(by index: NSNumber, completionHandler: @escaping (Data?) -> Void) {
        let person = people[index.intValue]
        networkService.fetchData(for: person) { result in
            switch result {
            case .success(let imageData):
                completionHandler(imageData)
            case .failure(_):
                completionHandler(nil)
            }
        }
    }
}
