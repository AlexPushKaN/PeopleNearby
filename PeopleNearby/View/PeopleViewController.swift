//
//  PeopleViewController.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit
import CoreLocation

final class PeopleViewController: UIViewController {
    private let peopleView: PeopleView = PeopleView()
    private var peopleViewModel: PeopleViewModelProtocol
    private var selectedPerson: Person?
    private let cacheImages = NSCache<NSNumber, UIImage>()

    init(viewModel: PeopleViewModelProtocol) {
        self.peopleViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = peopleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBindigs()
        fetchPeople()
        startUpdatingLocations()
    }
    
    private func setupTableView() {
        peopleView.tableView.dataSource = self
        peopleView.tableView.delegate = self
    }
    
    private func setupBindigs() {
        peopleViewModel.onPeopleUpdated = { [weak self] in
            guard let self else { return }
            peopleView.tableView.reloadData()
        }
    }
    
    private func fetchPeople() {
        peopleViewModel.fetchPeople()
    }
    
    private func startUpdatingLocations() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            guard let self else { return }
            peopleViewModel.updatePeopleLocations()
        }
    }

    private func getImage(from person: Person, with index: NSNumber) -> UIImage? {
        if let cachedImage = cacheImages.object(forKey: index) {
            return cachedImage
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let url = URL(string: person.avatarURL) {
                    URLSession.shared.dataTask(with: url) { data, _, _ in
                        if let data = data, let image = UIImage(data: data) {
                            self?.cacheImages.setObject(image, forKey: index)
                            DispatchQueue.main.async {
                                self?.peopleView.tableView.reloadData()
                            }
                        }
                    }.resume()
                }
            }
        }
        return nil
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleViewModel.people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PersonCell.reuseIdentifier, for: indexPath) as! PersonCell
        let person = peopleViewModel.people[indexPath.row]
        let index = NSNumber(value: indexPath.item)
        if let userLocation = selectedPerson?.getCurrentLocation() ?? peopleViewModel.getCurrentLocation() {
            let distance = peopleViewModel.calculateDistance(from: userLocation, to: person)
            cell.configure(person: person, distance: distance)
        }
        if let image = getImage(from: person, with: index) {
            cell.setAvatar(image: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = peopleViewModel.people[indexPath.row]
        if selectedPerson?.id == person.id {
            selectedPerson = nil
            peopleView.selectedPersonView.isHidden = true
        } else {
            selectedPerson = person
            peopleView.selectedPersonView.configure(with: person)
            peopleView.selectedPersonView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
