//
//  PeopleService.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import Foundation

final class PeopleService {
    func fetchPeople(completion: @escaping ([Person]) -> Void) {
        let people = [
            Person(
                id: "1",
                name: "Таня",
                avatarURL: "https://images.dog.ceo/breeds/australian-kelpie/Resized_20200214_191118_346649120350209.jpg", 
                location: Location(latitude: 34.0522, longitude: -118.2437)
            ),
            Person(
                id: "2",
                name: "Саша",
                avatarURL: "https://images.dog.ceo/breeds/waterdog-spanish/20180723_185559.jpg",
                location: Location(latitude: 37.7749, longitude: -122.4194)
            ),
            Person(
                id: "3",
                name: "Маша",
                avatarURL: "https://images.dog.ceo/breeds/sheepdog-english/n02105641_1212.jpg",
                location: Location(latitude: 35.5543, longitude: -121.3925)
            ),
        ]
        completion(people)
    }
    
    func updateLocations(for people: [Person], completion: @escaping ([Person]) -> Void) {
        var updatedPeople = [Person]()
        for person in people {
            let newLatitude = person.location.latitude + Double.random(in: -0.01...0.01)
            let newLongitude = person.location.longitude + Double.random(in: -0.01...0.01)
            let updatedPerson = Person(
                id: person.id,
                name: person.name,
                avatarURL: person.avatarURL, 
                location: Location(latitude: newLatitude, longitude: newLongitude)
            )
            updatedPeople.append(updatedPerson)
        }
        completion(updatedPeople)
    }
}
