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
    var currentLocation: CLLocation? { get set }
    var onPeopleUpdated: (() -> Void)? { get set }
    
    func requestLocationAccess(completionHandler: @escaping (Result<Void, LocationError>) -> Void)
    func getLocationAndFetchPeople()
    func updatePeopleLocations(except: Person?)
    func calculateDistance(from location: CLLocation, to person: Person) -> Double
    func fetchImageData(by index: NSNumber, completionHandler: @escaping (Data?) -> Void)
}
