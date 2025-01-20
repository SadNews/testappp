//
//  NutritionViewModel.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//


final class NutritionViewModel {
    private let router: NutritionRouter
    
    init(router: NutritionRouter) {
        self.router = router
    }
    
    func didSelectMealPlans() {
        router.showMealPlans()
    }
    
    func didSelectMealIdeas() {
        router.showMealIdeas()
    }
}
