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
    
    var people: [Person] = [] {
        didSet { onPeopleUpdated?() }
    }

    var onPeopleUpdated: (() -> Void)?
    
    init(services people: PeopleService, and: LocationManager) {
        self.peopleService = people
        self.locationManager = and
    }
    
    func fetchPeople() {
        peopleService.fetchPeople { [weak self] people in
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
        return locationManager.getCurrentLocation()
    }
}
