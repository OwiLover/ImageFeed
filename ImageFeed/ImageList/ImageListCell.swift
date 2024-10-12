//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/11/24.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImageListCell"
    
    private weak var delegate: ImageListCellDelegate?
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var cellGradient: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    func configureCell(imageUrlString: String, date: String, likeStatus: Bool) {
        guard let url = URL(string: imageUrlString) else { return }
        
        cellImage.backgroundColor = .ypWhiteAlpha50
        cellImage.contentMode = .center
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Stub.png")) {[weak self] _ in
            self?.cellImage.contentMode = .scaleAspectFill
        }

        setDateLabel(date: date)

        setLikeStatus(isLiked: likeStatus)
    }
    
    func setLikeStatus(isLiked: Bool) {
        let buttonImageName = isLiked ? "Active" : "No Active"
        guard let buttonImage = UIImage(named: buttonImageName) else {
            return
        }
        setLikeButtonImage(image: buttonImage)
    }
    
    func setupDelegate(delegate: ImageListCellDelegate) {
        self.delegate = delegate
    }
    
    private func setLikeButtonImage(image: UIImage) {
        likeButton.setImage(image, for: .normal)
    }
    
    private func setDateLabel(date: String) {
        dateLabel.text = date
    }
    
    @IBAction func likeButtonTouchUpInside(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}


