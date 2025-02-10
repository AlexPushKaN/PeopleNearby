//
//  PeopleView.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit

final class PeopleView: UIView {
    let tableView = UITableView()
    let selectedPersonView = SelectedPersonView()
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        selectedPersonView.isHidden = true
        selectedPersonView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(selectedPersonView)
        
        tableView.register(PersonCell.self, forCellReuseIdentifier: PersonCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            selectedPersonView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            selectedPersonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedPersonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedPersonView.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: selectedPersonView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func activityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
