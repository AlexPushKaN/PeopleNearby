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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
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
        
        NSLayoutConstraint.activate([
            selectedPersonView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            selectedPersonView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedPersonView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedPersonView.heightAnchor.constraint(equalToConstant: 80),
            
            tableView.topAnchor.constraint(equalTo: selectedPersonView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
