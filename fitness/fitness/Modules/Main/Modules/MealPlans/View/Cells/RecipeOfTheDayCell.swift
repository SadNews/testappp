//
//  RecipeOfTheDayCell.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import UIKit
import Combine

final class RecipeOfTheDayCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecipeOfTheDayCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }().prepareForAutoLayout()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }().prepareForAutoLayout()
    
    private let recipeLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .limeGreen
        label.textColor = .appBlack
        label.font = UIFont.poppins(.medium, size: 12)
        label.textAlignment = .center
        label.textInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        return label
    }().prepareForAutoLayout()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .appBlack90
        return view
    }().prepareForAutoLayout()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .limeGreen
        label.font = UIFont.poppins(.medium, size: 14)
        return label
    }().prepareForAutoLayout()
    
    private let mealCookTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }().prepareForAutoLayout()
    
    private let mealCalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }().prepareForAutoLayout()

    private let favoriteButton = UIButton().prepareForAutoLayout()
    
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

extension RecipeOfTheDayCell {
    func configure(with meal: Meal) {
        contentView.backgroundColor = .appPurple
        
        if let imageUrlString = meal.mealImageUrl, let imageUrl = URL(string: imageUrlString) {
            cancellable = DIContainer.shared.imageCache.loadImage(from: imageUrl)
                .sink { [weak self] image in
                    self?.backgroundImageView.image = image
                }
        }
        
        recipeLabel.text = "Recipe of the day"
        mealNameLabel.text = meal.mealName
        mealCookTimeLabel.text = "\(meal.mealCookTime) Minutes"
        mealCalLabel.text = "\(meal.mealCal ?? "") cal"
        
        let favoriteImage = (meal.mealIsFavorite ?? false) ? UIImage(resource: .selectedFavoriteIcon) : UIImage(resource: .unselectedFavoriteIcon) 
        favoriteButton.setImage(favoriteImage, for: .normal)
        favoriteButton.tintColor = .white
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(recipeLabel)
        
        bottomContainerView.backgroundColor = .appBlack90
        containerView.addSubview(bottomContainerView)
        bottomContainerView.addSubview(mealNameLabel)
        bottomContainerView.addSubview(favoriteButton)
        bottomContainerView.addSubview(mealCookTimeLabel)
        bottomContainerView.addSubview(mealCalLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        containerView.topAnchor ~= contentView.topAnchor + Constants.containerPadding
        containerView.leadingAnchor ~= contentView.leadingAnchor + Constants.containerPadding
        containerView.trailingAnchor ~= contentView.trailingAnchor - Constants.containerPadding
        containerView.bottomAnchor ~= contentView.bottomAnchor - Constants.containerPadding
        
        backgroundImageView.topAnchor ~= containerView.topAnchor
        backgroundImageView.leadingAnchor ~= containerView.leadingAnchor
        backgroundImageView.trailingAnchor ~= containerView.trailingAnchor
        backgroundImageView.bottomAnchor ~= containerView.bottomAnchor
        
        recipeLabel.topAnchor ~= backgroundImageView.topAnchor
        recipeLabel.trailingAnchor ~= backgroundImageView.trailingAnchor
        
        bottomContainerView.leadingAnchor ~= backgroundImageView.leadingAnchor
        bottomContainerView.trailingAnchor ~= backgroundImageView.trailingAnchor
        bottomContainerView.bottomAnchor ~= backgroundImageView.bottomAnchor
        
        mealNameLabel.topAnchor ~= bottomContainerView.topAnchor + Constants.mealNameBottomSpacing
        mealNameLabel.leadingAnchor ~= bottomContainerView.leadingAnchor + Constants.labelPadding
        mealNameLabel.trailingAnchor ~= favoriteButton.leadingAnchor + Constants.favoriteButtonSpacing
        
        favoriteButton.centerYAnchor ~= mealNameLabel.centerYAnchor
        favoriteButton.trailingAnchor ~= bottomContainerView.trailingAnchor + Constants.favoriteButtonSpacing
        favoriteButton.widthAnchor ~= Constants.favoriteButtonSize
        favoriteButton.heightAnchor ~= Constants.favoriteButtonSize
        
        mealCookTimeLabel.topAnchor ~= mealNameLabel.bottomAnchor + Constants.mealNameBottomSpacing
        mealCookTimeLabel.leadingAnchor ~= bottomContainerView.leadingAnchor + Constants.labelPadding
        mealCookTimeLabel.bottomAnchor ~= bottomContainerView.bottomAnchor + Constants.mealCookTimeBottomSpacing
        
        mealCalLabel.centerYAnchor ~= mealCookTimeLabel.centerYAnchor
        mealCalLabel.leadingAnchor ~= mealCookTimeLabel.trailingAnchor + Constants.mealCalSpacing
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButtonAction?()
    }
}

private extension RecipeOfTheDayCell {
    enum Constants {
        static let containerPadding: CGFloat = 32
        static let labelPadding: CGFloat = 16
        static let favoriteButtonSize: CGFloat = 24
        static let favoriteButtonSpacing: CGFloat = -8
        static let mealNameBottomSpacing: CGFloat = 4
        static let mealCookTimeBottomSpacing: CGFloat = -8
        static let mealCalSpacing: CGFloat = 16
    }
}
