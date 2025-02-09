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
    private let locationManager: LocationManager
    var onPeopleUpdated: (() -> Void)?
    var people: [Person] = [] {
        didSet { onPeopleUpdated?() }
    }

    init(services people: PeopleService, and: LocationManager) {
        self.peopleService = people
        self.locationManager = and
    }
    
    func fetchPeople(nearby location: CLLocation) {
        peopleService.fetchPeople(nearby: location) { [weak self] people in
            self?.people = people
        }
    }
    
    func updatePeopleLocations() {
        peopleService.updateLocations(for: people) { [weak self] updatedPeople in
            self?.people = updatedPeople
        }
    }
    
    func calculateDistance(from location: CLLocation, to person: Person) -> Double {
        let personLocation = person.getCurrentLocation()
        return location.distance(from: personLocation) / 1000
    }
    
    func getCurrentLocation() -> CLLocation? {
        if let location = locationManager.getCurrentLocation() {
            return location
        } else {
            return CLLocation(latitude: 59.9386, longitude: 30.3141) // - Координаты Петербурга по умолчанию
        }
    }
}
