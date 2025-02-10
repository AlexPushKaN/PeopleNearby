//
//  ViewControllerFactory.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation

final class ViewControllerFactory {
    static func createController() -> PeopleViewController? {
        let locationManager = LocationManager.shared
        let peopleService = PeopleService()
        let networkService = NetworkService()
        let viewModel = PeopleViewModel(services: peopleService, networkService, and: locationManager)
        let controller = PeopleViewController(viewModel: viewModel)
        return controller
    }
}
