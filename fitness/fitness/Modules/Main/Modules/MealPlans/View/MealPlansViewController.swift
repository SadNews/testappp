//
//  MealPlansViewController.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit
import Combine

final class MealPlansViewController: UIViewController {
    
    private let viewModel: MealPlansViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Meal>!
    
    init(viewModel: MealPlansViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBlack
        setupCollectionView()
        configureDataSource()
        bindViewModel()
        viewModel.fetchMeals(page: 1)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionSpacing
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .recipeOfTheDay:
                return self.createRecipeOfTheDaySection()
            case .recommended:
                return self.createRecommendedSection()
            case .recipesForYou:
                return self.createRecipesForYouSection()
            }
        }, configuration: config)
    }
    
    private func createRecipeOfTheDaySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.recipeOfTheDayHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.recipeOfTheDayHeight)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 0, bottom: Constants.sectionContentInset, trailing: 0
        )
        return section
    }
    
    private func createRecommendedSection() -> NSCollectionLayoutSection {
        let itemWidth = (view.bounds.width - 70 - Constants.recommendedItemSpacing) / 2
        let itemHeight = itemWidth / 1.3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(itemHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth * 2 + Constants.recommendedItemSpacing),
            heightDimension: .absolute(itemHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(Constants.recommendedItemSpacing)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.sectionContentInset,
            leading: Constants.recommendedSectionInset,
            bottom: Constants.sectionContentInset,
            trailing: Constants.recommendedSectionInset
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createRecipesForYouSection() -> NSCollectionLayoutSection {
        let width = view.bounds.width - Constants.recipesForYouInset * 2
        let height = width / 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(width),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.sectionContentInset,
            leading: Constants.recipesForYouInset,
            bottom: Constants.sectionContentInset,
            trailing: Constants.recipesForYouInset
        )
        section.interGroupSpacing = Constants.recipesForYouGroupSpacing
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(Constants.headerHeight)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func configureDataSource() {
        let recipeCellRegistration = UICollectionView.CellRegistration<RecipeOfTheDayCell, Meal> { cell, _, meal in
            cell.configure(with: meal)
            cell.favoriteButtonAction = { [weak self] in
                self?.viewModel.toggleFavorite(for: meal)
            }
        }
        
        let recommendedCellRegistration = UICollectionView.CellRegistration<RecommendedMealCell, Meal> { cell, _, meal in
            cell.configure(with: meal)
            cell.favoriteButtonAction = { [weak self] in
                self?.viewModel.toggleFavorite(for: meal)
            }
        }
        
        let recipeForYouCellRegistration = UICollectionView.CellRegistration<RecipeForYouCell, Meal> { cell, _, meal in
            cell.configure(with: meal)
            cell.favoriteButtonAction = { [weak self] in
                self?.viewModel.toggleFavorite(for: meal)
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { supplementaryView, _, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .recommended:
                supplementaryView.titleLabel.text = "Recommended"
            case .recipesForYou:
                supplementaryView.titleLabel.text = "Recipes for you"
            default:
                supplementaryView.titleLabel.text = ""
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Meal>(
            collectionView: collectionView
        ) { collectionView, indexPath, meal in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .recipeOfTheDay:
                return collectionView.dequeueConfiguredReusableCell(
                    using: recipeCellRegistration, for: indexPath, item: meal
                )
            case .recommended:
                return collectionView.dequeueConfiguredReusableCell(
                    using: recommendedCellRegistration, for: indexPath, item: meal
                )
            case .recipesForYou:
                return collectionView.dequeueConfiguredReusableCell(
                    using: recipeForYouCellRegistration, for: indexPath, item: meal
                )
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath
            )
        }
    }
    
    private func bindViewModel() {
        viewModel.$snapshot
            .receive(on: DispatchQueue.main)
            .sink { [weak self] snapshot in
                self?.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { errorMessage in
                // Handle error
            }
            .store(in: &cancellables)
    }
}

extension MealPlansViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let meal = dataSource.itemIdentifier(for: indexPath) else { return }
        viewModel.didSelectMeal(with: meal.id)
    }
}

extension MealPlansViewController {
    enum Section: CaseIterable {
        case recipeOfTheDay
        case recommended
        case recipesForYou
    }
}

private extension MealPlansViewController {
     enum Constants {
        static let interSectionSpacing: CGFloat = 16
        static let sectionContentInset: CGFloat = 16
        static let headerHeight: CGFloat = 44
        static let recipeOfTheDayHeight: CGFloat = 300
        static let recommendedItemSpacing: CGFloat = 8
        static let recommendedSectionInset: CGFloat = 35
        static let recipesForYouInset: CGFloat = 32
        static let recipesForYouGroupSpacing: CGFloat = 16
    }
}
