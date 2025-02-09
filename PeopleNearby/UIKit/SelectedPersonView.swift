//
//  SelectedPersonView.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit

final class SelectedPersonView: UIView {
    private enum Constants {
        static let padding: CGFloat = 16.0
        static let cornerRadius: CGFloat = 10.0
        static let sizeAvatar: CGFloat = 50.0
    }
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = Constants.cornerRadius
        avatarImageView.layer.masksToBounds = true

        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nameLabel.textColor = .black

        addSubview(avatarImageView)
        addSubview(nameLabel)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.padding),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.sizeAvatar),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.sizeAvatar),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.padding),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.padding)
        ])
    }

    func configure(with person: Person) {
        nameLabel.text = person.name
        if let url = URL(string: person.avatarURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}

