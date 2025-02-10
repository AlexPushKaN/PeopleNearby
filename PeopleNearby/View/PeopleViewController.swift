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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        peopleViewModel.requestLocationAccess {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if let currentCoordinate = peopleViewModel.getCurrentLocation() {
                    peopleView.activityIndicator(show: true)
                    peopleViewModel.fetchPeople(nearby: currentCoordinate) {
                        self.peopleView.activityIndicator(show: false)
                    }
                    startUpdatingLocations()
                }
            }
        }
    }
    
    private func setupTableView() {
        peopleView.tableView.dataSource = self
        peopleView.tableView.delegate = self
    }
    
    private func setupBindigs() {
        peopleViewModel.onPeopleUpdated = { [weak self] in
            guard let self = self else { return }
            self.peopleView.tableView.reloadData()
        }
    }
    
    private func startUpdatingLocations() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.peopleViewModel.updatePeopleLocations()
        }
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
        if let userLocation = selectedPerson?.getCurrentLocation().toCLLocation() ?? peopleViewModel.getCurrentLocation() {
            let distance = peopleViewModel.calculateDistance(from: userLocation, to: person)
            cell.configure(person: person, distance: distance)
        }
        
        let index = NSNumber(value: indexPath.item)
        if let image = cacheImages.object(forKey: index) {
            cell.setAvatar(image: image)
        } else {
            peopleViewModel.fetchImageData(by: index, completionHandler: { [weak self] imageData in
                guard let self else { return }
                switch imageData {
                case .none:
                    if let systemImage = UIImage(systemName: "nosign") {
                        cacheImages.setObject(systemImage, forKey: index)
                        cell.setAvatar(image: systemImage)
                    }
                case .some(let imageData):
                    if let image = UIImage(data: imageData) {
                        cacheImages.setObject(image, forKey: index)
                        cell.setAvatar(image: image)
                    }
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let person = peopleViewModel.people[indexPath.row]
        if self.selectedPerson?.id == person.id {
            self.selectedPerson = nil
            self.peopleView.selectedPersonView.isHidden = true
        } else {
            self.selectedPerson = person
            self.peopleView.selectedPersonView.configure(with: person)
            self.peopleView.selectedPersonView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
