//
//  RecipeForYouCell.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import UIKit
import Combine

final class RecipeForYouCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecipeForYouCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        view.layer.cornerRadius = 20
        return view
    }().prepareForAutoLayout()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true 
        return imageView
    }().prepareForAutoLayout()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.poppins(.medium, size: 18)
        return label
    }().prepareForAutoLayout()
    
    private let mealCalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.leagueSpartan(.light, size: 12)
        return label
    }().prepareForAutoLayout()
    
    private let mealCookTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.leagueSpartan(.light, size: 12)
        return label
    }().prepareForAutoLayout()
    
    private let favoriteButton = UIButton().prepareForAutoLayout()
    
    private let infoStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        return stack
    }().prepareForAutoLayout()
    
    private var cancellable: AnyCancellable?
    
    var favoriteButtonAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecipeForYouCell {
    func configure(with meal: Meal) {
        mealNameLabel.text = meal.mealName
        mealCookTimeLabel.text = "\(meal.mealCookTime) Minutes"
        mealCalLabel.text = "\(meal.mealCal ?? "") cal"
        let favoriteImage = (meal.mealIsFavorite ?? false) ? UIImage(resource: .selectedFavoriteIcon) : UIImage(resource: .unselectedFavoriteIcon) 
        favoriteButton.setImage(favoriteImage, for: .normal)
        
        if let imageUrlString = meal.mealImageUrl, let imageUrl = URL(string: imageUrlString) {
            cancellable = DIContainer.shared.imageCache.loadImage(from: imageUrl)
                .sink { [weak self] image in
                    self?.imageView.image = image
                }
        }
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)

        containerView.addSubview(imageView)
        containerView.addSubview(mealNameLabel)
        containerView.addSubview(infoStackView)
        containerView.addSubview(favoriteButton)

        favoriteButton.tintColor = .appBlack
        
        infoStackView.addArrangedSubview(mealCookTimeLabel)
        infoStackView.addArrangedSubview(mealCalLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        let leftGuide = UILayoutGuide()
        containerView.addLayoutGuide(leftGuide)
        
        containerView.topAnchor ~= contentView.topAnchor
        containerView.leadingAnchor ~= contentView.leadingAnchor
        containerView.trailingAnchor ~= contentView.trailingAnchor
        containerView.bottomAnchor ~= contentView.bottomAnchor
        
        imageView.centerYAnchor ~= containerView.centerYAnchor
        imageView.trailingAnchor ~= containerView.trailingAnchor
        imageView.widthAnchor ~= containerView.widthAnchor * 0.5
        imageView.heightAnchor ~= containerView.heightAnchor
        
        leftGuide.topAnchor ~= containerView.topAnchor
        leftGuide.leadingAnchor ~= containerView.leadingAnchor
        leftGuide.trailingAnchor ~= imageView.leadingAnchor
        leftGuide.bottomAnchor ~= containerView.bottomAnchor
        
        mealNameLabel.centerXAnchor ~= leftGuide.centerXAnchor
        mealNameLabel.centerYAnchor ~= containerView.centerYAnchor + Constants.mealNameYOffset
        
        infoStackView.topAnchor ~= mealNameLabel.bottomAnchor + Constants.infoStackViewTopPadding
        infoStackView.centerXAnchor ~= leftGuide.centerXAnchor
        
        favoriteButton.topAnchor ~= containerView.topAnchor + Constants.favoriteButtonTopPadding
        favoriteButton.trailingAnchor ~= imageView.trailingAnchor + Constants.favoriteButtonTrailingPadding
        favoriteButton.widthAnchor ~= Constants.favoriteButtonSize
        favoriteButton.heightAnchor ~= Constants.favoriteButtonSize
    }

    @objc private func favoriteButtonTapped() {
        favoriteButtonAction?()
    }
}

private extension RecipeForYouCell {
     enum Constants {
        static let favoriteButtonSize: CGFloat = 24
        static let favoriteButtonTopPadding: CGFloat = 8
        static let favoriteButtonTrailingPadding: CGFloat = -8
        static let mealNameYOffset: CGFloat = -16
        static let infoStackViewTopPadding: CGFloat = 4
    }
}
