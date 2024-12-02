//
//  RecommendedMealCell.swift
//  fitness
//
//  Created by Andrey Ushakov on 02.12.2024.
//

import UIKit
import Combine

final class RecommendedMealCell: UICollectionViewCell {
    
    static let reuseIdentifier = "RecommendedMealCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }().prepareForAutoLayout()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        return imageView
    }().prepareForAutoLayout()
    
    private let mealNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .limeGreen
        label.font = UIFont.poppins(.regular, size: 14)
        return label
    }().prepareForAutoLayout()
    
    private let mealCalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = UIFont.leagueSpartan(.light, size: 12)
        return label
    }().prepareForAutoLayout()
    
    private let mealCookTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.font = UIFont.leagueSpartan(.light, size: 12)
        return label
    }().prepareForAutoLayout()
    
    private let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.clipsToBounds = true
        return view
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

extension RecommendedMealCell {
    func configure(with meal: Meal) {
        if let imageUrlString = meal.mealImageUrl, let imageUrl = URL(string: imageUrlString) {
            cancellable = DIContainer.shared.imageCache.loadImage(from: imageUrl)
                .sink { [weak self] image in
                    self?.imageView.image = image
                }
        }
        
        mealNameLabel.text = meal.mealName
        mealCookTimeLabel.text = "\(meal.mealCookTime) Minutes"
        mealCalLabel.text = "\(meal.mealCal ?? "") cal"
        let favoriteImage = (meal.mealIsFavorite ?? false) ? UIImage(resource: .selectedFavoriteIcon) : UIImage(resource: .unselectedFavoriteIcon) 
        favoriteButton.setImage(favoriteImage, for: .normal)
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(blackView)
        blackView.addSubview(mealNameLabel)
        blackView.addSubview(mealCookTimeLabel)
        blackView.addSubview(mealCalLabel)
        blackView.addSubview(favoriteButton)
        
        favoriteButton.tintColor = .white
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

    }
    
    private func setupConstraints() {
        containerView.topAnchor ~= contentView.topAnchor
        containerView.leadingAnchor ~= contentView.leadingAnchor
        containerView.trailingAnchor ~= contentView.trailingAnchor
        containerView.bottomAnchor ~= contentView.bottomAnchor
        
        imageView.topAnchor ~= containerView.topAnchor
        imageView.leadingAnchor ~= containerView.leadingAnchor
        imageView.trailingAnchor ~= containerView.trailingAnchor
        imageView.heightAnchor ~= containerView.heightAnchor * (2.0 / 3.0)
        
        blackView.topAnchor ~= imageView.bottomAnchor - Constants.blackViewInset
        blackView.leadingAnchor ~= containerView.leadingAnchor + Constants.blackViewInset
        blackView.trailingAnchor ~= containerView.trailingAnchor - Constants.blackViewInset
        blackView.bottomAnchor ~= containerView.bottomAnchor - Constants.blackViewInset
        
        mealNameLabel.topAnchor ~= blackView.topAnchor + Constants.mealNameTopPadding
        mealNameLabel.leadingAnchor ~= blackView.leadingAnchor + Constants.labelHorizontalPadding
        mealNameLabel.trailingAnchor ~= favoriteButton.leadingAnchor - Constants.labelHorizontalPadding
        
        favoriteButton.centerYAnchor ~= mealNameLabel.centerYAnchor
        favoriteButton.trailingAnchor ~= blackView.trailingAnchor - Constants.labelHorizontalPadding
        favoriteButton.widthAnchor ~= Constants.favoriteButtonSize
        favoriteButton.heightAnchor ~= Constants.favoriteButtonSize
        
        mealCookTimeLabel.topAnchor ~= mealNameLabel.bottomAnchor + Constants.labelVerticalSpacing
        mealCookTimeLabel.leadingAnchor ~= blackView.leadingAnchor + Constants.labelHorizontalPadding
        mealCookTimeLabel.bottomAnchor ~= blackView.bottomAnchor - Constants.labelHorizontalPadding
        
        mealCalLabel.centerYAnchor ~= mealCookTimeLabel.centerYAnchor
        mealCalLabel.trailingAnchor ~= blackView.trailingAnchor - Constants.labelHorizontalPadding
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteButtonAction?()
    }
}

private extension RecommendedMealCell {
     enum Constants {
        static let blackViewInset: CGFloat = 1
        static let mealNameTopPadding: CGFloat = 2
        static let labelHorizontalPadding: CGFloat = 8
        static let labelVerticalSpacing: CGFloat = 4
        static let favoriteButtonSize: CGFloat = 24
    }
}
