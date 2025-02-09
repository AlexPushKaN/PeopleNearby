//
//  PeopleViewModelProtocol.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation
import CoreLocation

protocol PeopleViewModelProtocol {
    var people: [Person] { get set }
    var onPeopleUpdated: (() -> Void)? { get set }
    
    func fetchPeople(nearby location: CLLocation)
    func updatePeopleLocations()
    func getCurrentLocation() -> CLLocation?
    func calculateDistance(from location: CLLocation, to person: Person) -> Double
}
