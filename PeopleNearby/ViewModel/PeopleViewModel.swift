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
    
    func requestLocationAccess(completionHandler completion: @escaping (Result<Void, Error>) -> Void) {
        locationManager.requestLocationAccess { result in
            completion(result.mapError { $0 as Error })
        }
    }
    
    func initialSetup(fetchPeople firstCompletionHandler: @escaping () -> Void,
                      updateLocations secondCompletionHandler: @escaping () -> Void) {
        locationManager.onFirstLocationUpdate = { [weak self] location in
            guard let self = self else { return }
            self.fetchPeople(nearby: location) {
                firstCompletionHandler()
            }
            secondCompletionHandler()
        }
        locationManager.startUpdatingLocation()
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
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.currentLocation
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
