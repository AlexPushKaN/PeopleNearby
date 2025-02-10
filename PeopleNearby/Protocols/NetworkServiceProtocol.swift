//
//  NetworkServiceProtocol.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 10.02.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData(
        for person: Person,
        completionHandler: @escaping (Result<Data, NetworkError>) -> Void
    )
}
