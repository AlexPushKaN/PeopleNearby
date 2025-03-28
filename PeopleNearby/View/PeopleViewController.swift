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
    
    private var updateTimer: Timer?

    init(viewModel: PeopleViewModelProtocol) {
        self.peopleViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        setupTableView()
        setupBindings()
        
        requestLocationAccess()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func willEnterForeground() {
        requestLocationAccess()
    }
    
    private func requestLocationAccess() {
        peopleViewModel.requestLocationAccess { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                peopleView.activityIndicator(show: true)
                peopleViewModel.getLocationAndFetchPeople()
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }
    
    private func showAlert(with error: LocationError) {
        print("Error: \(error.localizedDescription)")
        UIAlertController.showLocationErrorAlert(controller: self)
    }
    
    private func setupSubviews() {
        view.addSubview(peopleView)
        
        peopleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            peopleView.topAnchor.constraint(equalTo: view.topAnchor),
            peopleView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            peopleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            peopleView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        peopleView.tableView.dataSource = self
        peopleView.tableView.delegate = self
    }
    
    private func setupBindings() {
        peopleViewModel.onPeopleUpdated = { [weak self] in
            guard let self = self else { return }
            peopleView.tableView.reloadData()
            peopleView.activityIndicator(show: false)
            startUpdatingLocations()
        }
    }

    func startUpdatingLocations() {
        updateTimer?.invalidate()
        updateTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: true
        ) { [weak self] _ in
            guard let self = self else { return }
            self.peopleViewModel.updatePeopleLocations(except: self.selectedPerson)
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
        if let userLocation = selectedPerson?.getCurrentLocation().toCLLocation() ?? peopleViewModel.currentLocation {
            let distance = peopleViewModel.calculateDistance(from: userLocation, to: person)
            cell.configure(person: person, distance: distance)
        }
        
        let index = NSNumber(value: indexPath.item)
        if let image = cacheImages.object(forKey: index) {
            cell.setAvatar(image: image)
        } else {
            peopleViewModel.fetchImageData(by: index, completionHandler: { [weak self] imageData in
                guard let self else { return }
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) as? PersonCell {
                        switch imageData {
                        case .none:
                            if let systemImage = UIImage(systemName: "nosign") {
                                self.cacheImages.setObject(systemImage, forKey: index)
                                cell.setAvatar(image: systemImage)
                            }
                        case .some(let imageData):
                            if let image = UIImage(data: imageData) {
                                self.cacheImages.setObject(image, forKey: index)
                                cell.setAvatar(image: image)
                            }
                        }
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
            self.peopleViewModel.updatePeopleLocations(except: nil)
        } else {
            self.selectedPerson = person
            self.peopleView.selectedPersonView.configure(with: person)
            self.peopleView.selectedPersonView.isHidden = false
            self.peopleViewModel.updatePeopleLocations(except: selectedPerson)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
