//
//  HeaderView.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class HeaderView: UIView {
    
    private let backButton = UIButton(type: .system).prepareForAutoLayout()
    private let titleLabel = UILabel().prepareForAutoLayout()
    private let profileButton = UIButton(type: .system).prepareForAutoLayout()
    private let notificationsButton = UIButton(type: .system).prepareForAutoLayout()
    private let searchButton = UIButton(type: .system).prepareForAutoLayout()

    var onBackButtonTap: (() -> Void)?
    
    init(title: String) {
        super.init(frame: .zero)
        setupUI(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(title: String) {
        backgroundColor = .clear
        
        backButton.setImage(UIImage(resource: .leftArrowIcon), for: .normal)
        backButton.tintColor = .limeGreen
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        titleLabel.text = title
        titleLabel.font = .poppins(.bold, size: Constants.titleFontSize)
        titleLabel.textColor = .appPurple
        
        [profileButton, notificationsButton, searchButton].forEach { button in
            button.tintColor = .appPurple
            button.widthAnchor.constraint(equalToConstant: Constants.backButtonSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: Constants.backButtonSize.height).isActive = true
        }
        
        profileButton.setImage(UIImage(resource: .profileIcon), for: .normal)
        notificationsButton.setImage(UIImage(resource: .notificationsIcon), for: .normal)
        searchButton.setImage(UIImage(resource: .searchIcon), for: .normal)
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(profileButton)
        addSubview(notificationsButton)
        addSubview(searchButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        backButton.leadingAnchor ~= leadingAnchor + Constants.backButtonLeading
        backButton.centerYAnchor ~= centerYAnchor
        backButton.widthAnchor ~= Constants.backButtonIconSize.width
        backButton.heightAnchor ~= Constants.backButtonIconSize.height
        
        titleLabel.leadingAnchor ~= backButton.trailingAnchor + Constants.buttonSpacing
        titleLabel.centerYAnchor ~= centerYAnchor
        
        searchButton.trailingAnchor ~= trailingAnchor - Constants.horizontalPadding
        searchButton.centerYAnchor ~= centerYAnchor
        
        notificationsButton.trailingAnchor ~= searchButton.leadingAnchor - Constants.buttonSpacing
        notificationsButton.centerYAnchor ~= centerYAnchor
        
        profileButton.trailingAnchor ~= notificationsButton.leadingAnchor - Constants.buttonSpacing
        profileButton.centerYAnchor ~= centerYAnchor
    }
    
    @objc private func backButtonTapped() {
        onBackButtonTap?()
    }
}

private extension HeaderView {
     enum Constants {
        static let backButtonSize = CGSize(width: 20, height: 20)
        static let buttonSpacing: CGFloat = 20
        static let horizontalPadding: CGFloat = 32
        static let backButtonLeading: CGFloat = 16
        static let backButtonIconSize = CGSize(width: 6, height: 11)
        static let titleFontSize: CGFloat = 20
    }
    
}
