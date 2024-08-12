//
//  GradientView.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/12/24.
//

import UIKit

final class GradientView: UIView {
    
    let firstColor = UIColor.ypBlack.withAlphaComponent(0).cgColor
    let secondColor = UIColor.ypBlack.withAlphaComponent(0.2).cgColor
    
    override class var layerClass: AnyClass {
            return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let gradientLayer = layer as? CAGradientLayer else {
            return
        }
        
        gradientLayer.colors = [firstColor, secondColor]
    }
}
