//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/11/24.
//

import UIKit

final class ImageListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImageListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var cellGradient: UIView!
    
    func setCellImage(image: UIImage) {
        cellImage.image = image
    }
    
    func setDateLabel(date: String) {
        dateLabel.text = date
    }
    
    func setLikeButtonImage(image: UIImage) {
        likeButton.setImage(image, for: .normal)
    }
}
