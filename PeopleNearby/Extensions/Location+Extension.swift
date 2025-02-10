//
//  Location+Extension.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 10.02.2025.
//

import Foundation
import CoreLocation

extension Location {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}
