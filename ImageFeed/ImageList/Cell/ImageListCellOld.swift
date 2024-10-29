//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/11/24.
//
//
//import UIKit
//import Kingfisher
//
//
//
    /*
        Данная реализация сохранена исключительно ради вопроса и уже не рабоатет:
            Каждый раз для получения фото необходимо проходиться по массиву Photos в ImageListViewController
            и чем больше будет загружено фото, тем дольше придётся искать их в случае нажатия кнопки лайка.
            Почему-бы не хранить photo
            внутри ImageListCell и редактировать её состояние здесь?
            
            Или использовать словарь для хранения в виде [id:photo] в ImageListViewController и хранить id картинки в ImageListCell, чтобы потом его передавать в ImageListViewController. По идее при такой реализации время поиска не должно увеличиваться
     */

//final class ImageListCellOld: UITableViewCell {
//    
//    static let reuseIdentifier = "ImageListCell"
//    
//    private (set) var photo: Photo?
//    
//    private let imageListService = ImageListService.shared
//    
//    private lazy var dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.timeStyle = .none
//        return formatter
//    }()
//    
//    @IBOutlet private var cellImage: UIImageView!
//    @IBOutlet private var dateLabel: UILabel!
//    @IBOutlet private var likeButton: UIButton!
//    @IBOutlet private var cellGradient: UIView!
//    
//    @IBAction func likeButtonTouchUpInside(_ sender: Any) {
////        print("yay")
//        guard let photo else { return }
//        imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self]
//            result in
//            guard let self else { return }
//            
//            switch result {
//            case .success(let selectedPhoto):
//                let isLiked = selectedPhoto.photo.likedByUser
//                self.photo?.isLiked = isLiked
//                
//                print(isLiked ? "Photo was liked!" : "Photo was disliked!")
//                
//                self.setLikeStatus(isLiked: isLiked)
//            case .failure(let error):
//                print("something went wrong")
//                print(error)
//            }
//        }
//        print("yay")
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        cellImage.kf.cancelDownloadTask()
//    }
//    
//    func setCellImage(imageUrl: String) {
//        guard let url = URL(string: imageUrl) else { return }
//        cellImage.backgroundColor = .ypWhiteAlpha50
//        cellImage.contentMode = .center
//        cellImage.kf.indicatorType = .activity
//        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Stub.png")) {[weak self] _ in
//            self?.cellImage.contentMode = .scaleAspectFill
//        }
//    }
//    
//    func setDateLabel(date: String) {
//        dateLabel.text = date
//    }
//    
//    func setLikeButtonImage(image: UIImage) {
//        likeButton.setImage(image, for: .normal)
//    }
//    
//    func configureCell(photo: Photo) {
//        self.photo = photo
//
//        let imageUrlString = photo.thumbImageURL
//        
//        guard let url = URL(string: imageUrlString) else { return }
//        
//        cellImage.backgroundColor = .ypWhiteAlpha50
//        cellImage.contentMode = .center
//        cellImage.kf.indicatorType = .activity
//        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Stub.png")) {[weak self] _ in
//            self?.cellImage.contentMode = .scaleAspectFill
//        }
//        
//        let date = dateFormatter.string(from: photo.createdAt ?? Date())
//        setDateLabel(date: date)
//
//        setLikeStatus(isLiked: photo.isLiked)
//    }
//    
//    private func setLikeStatus(isLiked: Bool) {
//        let buttonImageName = isLiked ? "Active" : "No Active"
//        guard let buttonImage = UIImage(named: buttonImageName) else {
//            return
//        }
//        setLikeButtonImage(image: buttonImage)
//    }
//}

