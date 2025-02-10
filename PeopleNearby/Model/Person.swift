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
    
    func getCurrentLocation() -> Location {
        return location
    }
}

struct Location {
    let latitude: Double
    let longitude: Double
}
