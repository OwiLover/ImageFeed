//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/7/24.
//

import Foundation

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}
