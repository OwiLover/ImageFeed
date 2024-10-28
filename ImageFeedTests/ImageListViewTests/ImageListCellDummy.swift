//
//  ImageListCellDummy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//

@testable import ImageFeed
import UIKit

class ImageListCellDummy: UITableViewCell, ImageListCellProtocol {

    var delegate: (any ImageFeed.ImageListCellDelegate)?
    
    func configureCell(imageUrlString: String, date: String, likeStatus: Bool) { }
    
    func setLikeStatus(isLiked: Bool) { }
    
    func setupDelegate(delegate: any ImageFeed.ImageListCellDelegate) { }
}
