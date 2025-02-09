//
//  PersonCell.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 09.02.2025.
//

import UIKit

final class PersonCell: UITableViewCell {
    private enum Constants {
        static let spacing: CGFloat = 8.0
        static let padding: CGFloat = 16.0
        static let cornerRadius: CGFloat = 8.0
        static let sizeAvatar: CGFloat = 30.0
    }
    
    static let reuseIdentifier = String(describing: PersonCell.self)
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    private func setupViews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = Constants.cornerRadius
        avatarImageView.layer.masksToBounds = true
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .black
        distanceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        distanceLabel.textColor = .black
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(distanceLabel)

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.sizeAvatar),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.spacing),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),

            distanceLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: Constants.spacing),
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.spacing),
            distanceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.spacing),
        ])
    }
    
    func configure(person: Person, distance: Double) {
        nameLabel.text = person.name
        distanceLabel.text = String(format: "%.0f m", distance)
    }
    
    func setAvatar(image: UIImage) {
        avatarImageView.image = image
    }
}
