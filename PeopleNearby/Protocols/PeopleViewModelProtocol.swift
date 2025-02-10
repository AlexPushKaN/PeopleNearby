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
    
    func requestLocationAccess(completion: @escaping (Result<Void, Error>) -> Void)
    func fetchPeople(nearby location: CLLocation, completionHandler: @escaping () -> Void)
    func updatePeopleLocations(except: Person?)
    func getCurrentLocation() -> CLLocation?
    func calculateDistance(from location: CLLocation, to person: Person) -> Double
    func fetchImageData(by index: NSNumber, completionHandler: @escaping (Data?) -> Void)
}
