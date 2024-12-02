//
//  MealDetailsViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 03.12.2024.
//

import UIKit
import Combine

final class MealDetailsViewController: UIViewController {
    private let viewModel: MealDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let headerView = HeaderView(title: "Meal Details").prepareForAutoLayout()
    private let mealImageView = UIImageView().prepareForAutoLayout()
    private let mealNameLabel = UILabel().prepareForAutoLayout()
    private let mealCalLabel = UILabel().prepareForAutoLayout()
    private let mealTimeLabel = UILabel().prepareForAutoLayout()
    
    init(viewModel: MealDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMealDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        view.backgroundColor = .appWhite
        
        [headerView, mealImageView, mealNameLabel, mealCalLabel, mealTimeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        headerView.onBackButtonTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        headerView.topAnchor ~= view.safeAreaLayoutGuide.topAnchor
        headerView.leadingAnchor ~= view.leadingAnchor
        headerView.trailingAnchor ~= view.trailingAnchor
        headerView.heightAnchor ~= Constants.headerHeight
        
        mealImageView.topAnchor ~= headerView.bottomAnchor + Constants.mealImageTopPadding
        mealImageView.centerXAnchor ~= view.centerXAnchor
        mealImageView.widthAnchor ~= Constants.mealImageSize
        mealImageView.heightAnchor ~= Constants.mealImageSize
        
        mealNameLabel.topAnchor ~= mealImageView.bottomAnchor + Constants.labelTopSpacing
        mealNameLabel.centerXAnchor ~= view.centerXAnchor
        
        mealCalLabel.topAnchor ~= mealNameLabel.bottomAnchor + Constants.labelTopSpacing
        mealCalLabel.centerXAnchor ~= view.centerXAnchor
        
        mealTimeLabel.topAnchor ~= mealCalLabel.bottomAnchor + Constants.labelTopSpacing
        mealTimeLabel.centerXAnchor ~= view.centerXAnchor
    }
    
    private func bindViewModel() {
        viewModel.$meal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] meal in
                guard let meal = meal else { return }
                self?.mealNameLabel.text = meal.mealName
                self?.mealCalLabel.text = "Calories: \(meal.mealCal ?? "")"
                self?.mealTimeLabel.text = "Cook time: \(meal.mealCookTime) minutes"
            }
            .store(in: &cancellables)
    }
}

private extension MealDetailsViewController {
    enum Constants {
        static let headerHeight: CGFloat = 50
        static let mealImageSize: CGFloat = 200
        static let mealImageTopPadding: CGFloat = 16
        static let labelTopSpacing: CGFloat = 8
        static let containerPadding: CGFloat = 16
    }
}
