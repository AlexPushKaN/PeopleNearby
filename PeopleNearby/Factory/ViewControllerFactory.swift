//
//  ViewControllerFactory.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation

final class ViewControllerFactory {
    static func createController() -> PeopleViewController {
        let peopleService = PeopleService()
        let locationManager = LocationManager.shared
        let viewModel = PeopleViewModel(services: peopleService, and: locationManager)
        let controller = PeopleViewController(viewModel: viewModel)
        return controller
    }
}
