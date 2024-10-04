//
//  ViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/5/24.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName = Array(0..<20).map{ "\($0)" }
    
    private let photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("ImageList was loaded!")
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath
            else {
                print("Invalid segue destination")
                return
            }

            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        
        let imageName = photosName[indexPath.row]
        guard let image = UIImage(named: imageName) else {
            return
        }
        
        cell.setCellImage(image: image)
        
        let date = dateFormatter.string(from: Date())
        cell.setDateLabel(date: date)

        let buttonImageName = (indexPath.row % 2 != 0) ? "No Active" : "Active"
        guard let buttonImage = UIImage(named: buttonImageName) else {
            return
        }
        
        cell.setLikeButtonImage(image: buttonImage)
    }
}

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
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
        
        let imageName = photosName[indexPath.row]
        
        guard let image = UIImage(named: imageName) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - (imageInsets.left + imageInsets.right)
        let imageWidth = image.size.width
        
        let scale = imageViewWidth / imageWidth
        
        let height = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.photos.count {
            
        }
    }
}
