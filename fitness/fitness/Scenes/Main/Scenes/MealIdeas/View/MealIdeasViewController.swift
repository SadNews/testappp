//
//  MealIdeasViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class MealIdeasViewController: UIViewController {
    
    private let viewModel: MealIdeasViewModel
    
    init(viewModel: MealIdeasViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Meal Plans"
        
        let label = UILabel()
        label.text = "Meal Ideas Screen"
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
