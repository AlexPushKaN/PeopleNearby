//
//  ViewControllerFactory.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit

final class ViewControllerFactory {
    static func createController() -> UIViewController {
        let locationService = LocationService.shared
        let peopleService = PeopleService()
        let networkService = NetworkService()
        let viewModel = PeopleViewModel(services: peopleService, networkService, and: locationService)
        let controller = PeopleViewController(viewModel: viewModel)
        return controller
    }
}
