//
//  Person.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation
import CoreLocation

struct Person {
    let id: String
    let name: String
    let avatarURL: String
    var location: Location
    
    func getCurrentLocation() -> CLLocation {
        return CLLocation(latitude: location.latitude, longitude: location.longitude)
    }
}
