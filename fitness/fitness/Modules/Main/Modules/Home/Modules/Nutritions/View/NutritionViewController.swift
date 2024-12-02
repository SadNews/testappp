//
//  NutritionViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class NutritionViewController: UIViewController {
    
    private let viewModel: NutritionViewModel
    
    private let headerView = HeaderView(title: "Nutrition").prepareForAutoLayout()
    private let segmentedControl = AppSegmentedControl(items: ["Meal Plans", "Meal Ideas"]).prepareForAutoLayout()
    
    private var currentChildViewController: UIViewController?
    
    init(viewModel: NutritionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appBlack
        
        setupHeaderView()
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupHeaderView() {
        view.addSubview(headerView)
        
        headerView.topAnchor ~= view.safeAreaLayoutGuide.topAnchor
        headerView.leadingAnchor ~= view.leadingAnchor
        headerView.trailingAnchor ~= view.trailingAnchor
        headerView.heightAnchor ~= Constants.headerViewHeight
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.topAnchor ~= headerView.bottomAnchor + Constants.segmentedControlTopPadding
        segmentedControl.leadingAnchor ~= view.leadingAnchor + Constants.segmentedControlHorizontalPadding
        segmentedControl.trailingAnchor ~= view.trailingAnchor - Constants.segmentedControlHorizontalPadding
        segmentedControl.heightAnchor ~= Constants.segmentedControlHeight
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            viewModel.didSelectMealPlans()
        } else {
            viewModel.didSelectMealIdeas()
        }
    }
    
    func displayContentController(_ childViewController: UIViewController) {
        removeCurrentContentController()
        
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        childViewController.view.topAnchor ~= segmentedControl.bottomAnchor + Constants.childViewTopPadding
        childViewController.view.leadingAnchor ~= view.leadingAnchor
        childViewController.view.trailingAnchor ~= view.trailingAnchor
        childViewController.view.bottomAnchor ~= view.bottomAnchor
        
        childViewController.didMove(toParent: self)
        currentChildViewController = childViewController
    }
    
    func removeCurrentContentController() {
        if let currentChild = currentChildViewController {
            currentChild.willMove(toParent: nil)
            currentChild.view.removeFromSuperview()
            currentChild.removeFromParent()
            currentChildViewController = nil
        }
    }
}

private extension NutritionViewController {
    enum Constants {
        static let headerViewHeight: CGFloat = 50
        static let segmentedControlTopPadding: CGFloat = 20
        static let segmentedControlHorizontalPadding: CGFloat = 20
        static let segmentedControlHeight: CGFloat = 32
        static let childViewTopPadding: CGFloat = 20
    }
}
