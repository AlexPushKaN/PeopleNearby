//
//  PlugView.swift
//  PeopleNearby
//
//  Created by Александр Муклинов on 25.03.2025.
//

import UIKit

final class PlugView: UIView {
    lazy var infoTextView = {
        let textView = UITextView()
        textView.text = "Доступ к геолокации необходим для корректной работы приложения, пожалуйста разрешите доступ к геолокации"
        textView.textColor = .black
        textView.textAlignment = .center
        textView.textContainer.maximumNumberOfLines = 0
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        textView.layer.borderColor = UIColor.systemRed.withAlphaComponent(0.4).cgColor
        textView.layer.borderWidth = 2
        textView.layer.cornerRadius = 10
        textView.clipsToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var settigsButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        button.setTitle("Настройки", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onDidTap: (() -> Void)?
    
    init(handlerButton: @escaping () -> Void) {
        super.init(frame: .zero)
        
        onDidTap = handlerButton
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        isHidden = true
        
        addSubview(infoTextView)
        addSubview(settigsButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            infoTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoTextView.centerYAnchor.constraint(equalTo: centerYAnchor),
            infoTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            infoTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            infoTextView.heightAnchor.constraint(equalToConstant: 80),
            
            settigsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settigsButton.topAnchor.constraint(equalTo: infoTextView.bottomAnchor, constant: 16),
            settigsButton.widthAnchor.constraint(equalToConstant: 100),
            settigsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func didTapSettingsButton() {
        onDidTap?()
    }
}
