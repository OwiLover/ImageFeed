//
//  ImageListCellSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/28/24.
//
@testable import ImageFeed
import UIKit

class ImageListCellSpy: UITableViewCell, ImageListCellProtocol {
    
    var setLikeStatusCalled: Bool = false
    
    var configureCellCalled: Bool = false
    
    var checkLikeStatus: Bool?
    
    var delegate: (any ImageFeed.ImageListCellDelegate)?
    
    func configureCell(imageUrlString: String, date: String, likeStatus: Bool) {
        configureCellCalled = true
    }
    
    func setLikeStatus(isLiked: Bool) {
        setLikeStatusCalled = true
        checkLikeStatus = isLiked
    }
    
    func setupDelegate(delegate: any ImageFeed.ImageListCellDelegate) {
        self.delegate = delegate
    }
}
