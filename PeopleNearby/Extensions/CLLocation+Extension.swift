//
//  CLLocation+Extension.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 10.02.2025.
//

import Foundation
import CoreLocation

extension CLLocation {
    func toLocation() -> Location {
        return Location(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
}
