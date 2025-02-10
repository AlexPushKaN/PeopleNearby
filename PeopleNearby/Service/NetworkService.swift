//
//  NetworkService.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 10.02.2025.
//

import Foundation

enum NetworkError: Error {
    case noData
}

final class NetworkService: NetworkServiceProtocol {
    func fetchData(
        for person: Person,
        completionHandler: @escaping (Result<Data, NetworkError>) -> Void
    ) {
        DispatchQueue.global(qos: .utility).async {
            if let url = URL(string: person.avatarURL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        print("Ошибка при запросе данных изображения: \(error.localizedDescription)")
                        completionHandler(.failure(NetworkError.noData))
                    } else if let imageData = data {
                        completionHandler(.success(imageData))
                    }
                }.resume()
            }
        }
    }
}
