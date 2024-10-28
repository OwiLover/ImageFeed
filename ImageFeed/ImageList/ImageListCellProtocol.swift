//
//  ImageListCellProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/28/24.
//

import Foundation
import UIKit

protocol ImageListCellProtocol: UITableViewCell {
    
    var delegate: ImageListCellDelegate? { get }
    
    func configureCell(imageUrlString: String, date: String, likeStatus: Bool)
    
    func setLikeStatus(isLiked: Bool)
    
    func setupDelegate(delegate: ImageListCellDelegate)
}
