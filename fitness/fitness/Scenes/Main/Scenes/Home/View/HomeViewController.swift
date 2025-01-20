//
//  HomeViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let openNutritionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Open Nutrition", for: .normal)
        return button
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Home"
        
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(openNutritionButton)
        openNutritionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openNutritionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openNutritionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        openNutritionButton.addTarget(self, action: #selector(didTapOpenNutrition), for: .touchUpInside)
    }
    
    private func bindViewModel() {
    }
    
    @objc private func didTapOpenNutrition() {
        viewModel.coordinator?.showNutritionScreen()
    }
}
