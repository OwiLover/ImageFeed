//
//  CustomIndicator.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/8/24.
//

import UIKit
import Kingfisher

struct CustomIndicator: Indicator {
    var view: Kingfisher.IndicatorView = UIView()
//    view
    func startAnimatingView() { UIBlockingProgressHUD.show() }
    func stopAnimatingView() { UIBlockingProgressHUD.dismiss() }
    
    init() { }
}
