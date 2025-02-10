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
    private let locationManager: LocationManager
    private let accessLock = NSLock()
    
    var onPeopleUpdated: (() -> Void)?
    var people: [Person] = [] {
        didSet {
            onPeopleUpdated?()
        }
    }

    init(services people: PeopleService, _ network: NetworkServiceProtocol, and locationManager: LocationManager) {
        self.peopleService = people
        self.networkService = network
        self.locationManager = locationManager
    }
    
    func requestLocationAccess(completion: @escaping () -> Void) {
        locationManager.requestLocationAccess {
            completion()
        }
    }
    
    func fetchPeople(nearby location: CLLocation, completionHandler: @escaping () -> Void) {
        peopleService.fetchPeople(nearby: location) { [weak self] newPeople in
            guard let self = self else { return }
            self.people = newPeople
            completionHandler()
        }
    }

    func updatePeopleLocations() {
        peopleService.updateLocations(for: people) { [weak self] updatedPeople in
            guard let self = self else { return }
            self.people = updatedPeople
        }
    }
    
    func calculateDistance(from location: CLLocation, to person: Person) -> Double {
        let personLocation = person.getCurrentLocation().toCLLocation()
        return location.distance(from: personLocation) / 1000
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.getCurrentLocation()
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
