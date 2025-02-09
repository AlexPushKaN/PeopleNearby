//
//  PeopleService.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation
import CoreLocation

final class PeopleService {
    func fetchPeople(nearby location: CLLocation, completion: @escaping ([Person]) -> Void) {
        var people = [Person]()
        let queue = DispatchQueue(label: "customQueue", qos: .utility)
        let group = DispatchGroup()
        
        let maleNames = ["Александр", "Сергей", "Дмитрий", "Андрей", "Алексей", "Иван",
                         "Максим", "Евгений", "Михаил", "Владимир", "Павел", "Константин",
                         "Василий", "Олег", "Николай", "Виктор", "Григорий", "Юрий", "Станислав", "Игорь"]
        let femaleNames = ["Анна", "Мария", "Елена", "Ольга", "Наталья", "Татьяна", "Ирина",
                           "Светлана", "Екатерина", "Вера", "Любовь", "Людмила", "Анастасия",
                           "Дарья", "Юлия", "Полина", "Кристина", "Валентина", "Виктория", "Алёна"]
        let allNames = maleNames + femaleNames
        let peopleCount = Int.random(in: (10...20))
        
        for _ in 1...peopleCount {
            group.enter()
            queue.async {
                self.randomImageURLString { url in
                    let id = UUID().uuidString
                    let name = allNames.randomElement() ?? "Аноним"
                    let oldLatitude = location.coordinate.latitude
                    let oldLongitude = location.coordinate.longitude
                    let latitude = Double.random(in: oldLatitude - 5.0...oldLatitude + 5.0)
                    let longitude = Double.random(in: oldLongitude - 5.0...oldLongitude + 5)
                    let location = CLLocation(latitude: latitude, longitude: longitude)
                    let person = Person(
                        id: id,
                        name: name,
                        avatarURL: url,
                        location: location
                    )
                    queue.async(flags: .barrier) {
                        people.append(person)
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(people)
        }
    }
    
    func randomImageURLString(completion: @escaping (String) -> Void) {
        let defaultImageURLString = "https://images.dog.ceo/breeds/segugio-italian/n02090722_001.jpg"
        guard let URL = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        let urlRequest = URLRequest(url: URL)
        URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error = error {
                print("Ошибка при запросе: \(error.localizedDescription)")
                completion(defaultImageURLString)
                return
            }
            
            guard let data = data else {
                print("Нет данных в ответе")
                completion(defaultImageURLString)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["message"] as? String {
                    completion(result)
                } else {
                    print("Неверный формат ответа")
                    completion(defaultImageURLString)
                }
            } catch {
                print("Ошибка при парсинге JSON: \(error.localizedDescription)")
                completion(defaultImageURLString)
            }
        }.resume()
    }
    
    func updateLocations(for people: [Person], completion: @escaping ([Person]) -> Void) {
        var updatedPeople = [Person]()
        for person in people {
            let newLatitude = person.location.coordinate.latitude + Double.random(in: -0.01...0.01)
            let newLongitude = person.location.coordinate.longitude + Double.random(in: -0.01...0.01)
            let updatedPerson = Person(
                id: person.id,
                name: person.name,
                avatarURL: person.avatarURL, 
                location: CLLocation(latitude: newLatitude, longitude: newLongitude)
            )
            updatedPeople.append(updatedPerson)
        }
        completion(updatedPeople)
    }
}
