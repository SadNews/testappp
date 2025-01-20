//
//  ResourcesViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit
import Combine

final class ResourcesViewController: UIViewController {
    
    private let viewModel: ResourcesViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ResourcesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "ResourcesViewController"
    }
}
