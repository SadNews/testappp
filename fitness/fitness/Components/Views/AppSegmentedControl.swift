//
//  AppSegmentedControl.swift
//  fitness
//
//  Created by Andrey Ushakov on 01.12.2024.
//

import UIKit

final class AppSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
    }
    
    private func setupAppearance() {
        let selectedColor = UIColor.limeGreen
        let selectedTextColor = UIColor.appBlack
        let unselectedTextColor = UIColor.appPurple
        
        backgroundColor = .clear
        selectedSegmentTintColor = selectedColor
        layer.cornerRadius = 38
        layer.masksToBounds = true
        
        let font = UIFont.leagueSpartan(.medium, size: 17)
        
        setTitleTextAttributes([
            .font: font,
            .foregroundColor: unselectedTextColor
        ], for: .normal)
        
        setTitleTextAttributes([
            .font: font,
            .foregroundColor: selectedTextColor
        ], for: .selected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0..<numberOfSegments {
            let segment = subviews[index]
            segment.layer.masksToBounds = true
        }
    }
}
