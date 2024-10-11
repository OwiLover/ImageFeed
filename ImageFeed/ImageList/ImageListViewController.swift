//
//  ViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/5/24.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var photos: [Photo] = []
    
    private let imageListService = ImageListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let observer = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main, using: { [weak self]
            _ in
            guard let self else { return }
            self.updateCells()
        })
        print("ImageList was loaded!")
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                print("Invalid segue destination")
                return
            }
            let imageUrlString = photos[indexPath.row].largeImageURL
            viewController.imageUrlString = imageUrlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        cell.setupDelegate(delegate: self)
        var date = ""
        if let photoDate = photo.createdAt {
            date = dateFormatter.string(from: photoDate)
        }
        cell.configureCell(imageUrlString: photo.thumbImageURL, date: date, likeStatus: photo.isLiked)
    }
    
    func updateCells() {
        self.tableView.performBatchUpdates({
            let oldCount = self.photos.count
            self.photos = self.imageListService.photos
            let newCount = self.photos.count
            
            if oldCount != newCount {
                let indexPathArray = (oldCount..<newCount).map {
                    index in
                    return IndexPath(row: index, section: 0)
                }
                self.tableView.insertRows(at: indexPathArray, with: .automatic)
            }
        })
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        let imageWidth = CGFloat(photo.width)
        
        let scale = imageViewWidth / imageWidth
        
        let height = CGFloat(photo.height) * scale + imageInsets.top + imageInsets.bottom
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell), let photo = photos[safe: indexPath.row] else { return }
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self]
            result in
            guard let self else { return }
            
            switch result {
            case .success(let selectedPhoto):
                
                guard let index = self.photos.firstIndex(where: {
                    photo in
                    photo.id == selectedPhoto.photo.id
                }) else { return }
                
                let isLiked = selectedPhoto.photo.likedByUser
                
                let photo = self.photos[index]
                
                self.photos[index] = Photo(photo: photo, likeStatus: isLiked)
                
                print(isLiked ? "Photo was liked!" : "Photo was disliked!")
                
                cell.setLikeStatus(isLiked: isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                print(error)
                UIBlockingProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось изменить лайк", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
