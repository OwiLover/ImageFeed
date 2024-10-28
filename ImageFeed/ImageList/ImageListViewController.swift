//
//  ViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/5/24.
//

import UIKit
import Kingfisher

final class ImageListViewController: UIViewController, ImageListViewControllerProtocol {

    var presenter: ImageListViewPresenterProtocol?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
//    private var photos: [Photo] = []
    
    private var imageListServiceObserver: NSObjectProtocol?
    


    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ImageList was loaded! ", presenter != nil ? "And his Presenter!" : "But not his Presenter!")
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main, using: { [weak self]
            _ in
            guard let self else { return }
            presenter?.updateCells()
        })
        
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                print("Invalid segue destination")
                return
            }
            let imageUrlString = presenter?.photos[indexPath.row].largeImageURL
            viewController.imageUrlString = imageUrlString
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateCells(oldCount: Int, newCount: Int) {
        self.tableView.performBatchUpdates({ [weak self] in
            guard let self else { return }
            if oldCount != newCount {
                let indexPathArray = (oldCount..<newCount).map {
                    index in
                    return IndexPath(row: index, section: 0)
                }
                self.tableView.insertRows(at: indexPathArray, with: .automatic)
            }
        })
    }
    
    func getImageListCellIndexPath(_ cell: ImageListCell) -> IndexPath? {
        return tableView.indexPath(for: cell)
    }
    
    func showLoadingIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadingIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func setPresenter(presenter: ImageListViewPresenterProtocol) {
        self.presenter = presenter
        presenter.controller = self
    }
    
    func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Что-то пошло не так(", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: { _ in }))
        present(alertController, animated: true, completion: nil)
    }
    
    func configCell(for cell: ImageListCell, photo: Photo, date: String) {
        cell.setupDelegate(delegate: self)
        cell.configureCell(imageUrlString: photo.thumbImageURL, date: date, likeStatus: photo.isLiked)
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        presenter?.configureCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.photos[safe: indexPath.row] else { return 200 }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        let imageWidth = CGFloat(photo.width)
        
        let scale = imageViewWidth / imageWidth
        
        let height = CGFloat(photo.height) * scale + imageInsets.top + imageInsets.bottom
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }
}

extension ImageListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        presenter?.didTabLike(cell: cell)
    }
}
