//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/11/24.
//

import UIKit

class ImageListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImageListCell"
    
    @IBOutlet var cellImage: UIImageView!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    @IBOutlet var cellGradient: UIView!

    
}
