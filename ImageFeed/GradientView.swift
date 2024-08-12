//
//  GradientView.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/12/24.
//

import UIKit

class GradientView: UIView {
    
    let firstColor = UIColor.ypBlack.withAlphaComponent(0).cgColor
    let secondColor = UIColor.ypBlack.withAlphaComponent(0.2).cgColor
    
    override class var layerClass: AnyClass {
            return CAGradientLayer.classForCoder()
    }
    
    //перепробовав много всего, толко данное решение смогло заработать, не знаю на сколько оно оптимальное
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [firstColor, secondColor]
    }
    
}
