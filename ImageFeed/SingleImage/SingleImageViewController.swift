//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/19/24.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    var imageUrlString: String?
    
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: { [weak self] in
            guard let self else { return }
            self.imageView.kf.cancelDownloadTask()
        })
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: .none)
        present(activityController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        guard let imageUrlString else { return }
        loadImage(imageUrlString: imageUrlString)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let boundsSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = boundsSize.width / imageSize.width
        let vScale = boundsSize.height / imageSize.height
        
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        
        let x = (newContentSize.width - boundsSize.width) / 2
        let y = (newContentSize.height - boundsSize.height) / 2
        
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func loadImage(imageUrlString: String) {
        guard let imageUrl = URL(string: imageUrlString), let placeholder = UIImage(named: "Stub.png") else { return }
        print("Placeholder size: ", placeholder.size)
        imageView.frame.size = placeholder.size
        rescaleAndCenterImageInScrollView(image: placeholder)
        scrollView.isScrollEnabled = false
        
        setImage(imageUrl: imageUrl, placeholder: placeholder)
    }
    
    func showError(imageUrl: URL, placeholder: UIImage) {
        let alert = UIAlertController(title: "Что-то пошло не так(", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Не надо", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let actionRestart = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.setImage(imageUrl: imageUrl, placeholder: placeholder)
        }
        alert.addAction(actionCancel)
        alert.addAction(actionRestart)
        self.present(alert, animated: true)
    }
    
    /*
     Мне показалось логичным использовать в качестве индикатора загрузки реализацию из KingsFisher, поскольку она не блокирует экран и пользователь может выйти не дождидаясь загрузки фото
     Однако данная реализация имела свои трудности (Например возможность зумить Placeholder, выступающий в виде значка Splash)
     Также значок немного отходит от макета (в макете логотип отцентрирован по X, но не отцентрирован по Y, при этом по Y не найдено никакой логики, почему отсутствует симметрия (например разница между SafeArea и View по Y сверху не сходится c разницей по Y снизу ни с кнопкой Share, ни с SafeArea, ни с View
     */
    
    func setImage(imageUrl: URL, placeholder: UIImage) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: imageUrl, placeholder: placeholder, options: [.scaleFactor(UIScreen.main.scale), .backgroundDecode]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let result):
                self.scrollView.isScrollEnabled = true
                print("Picture loaded!", result)
                let image = result.image
                self.imageView.frame.size = image.size
                self.rescaleAndCenterImageInScrollView(image: image)
            case .failure(let error):
                print(error)
                showError(imageUrl: imageUrl, placeholder: placeholder)
            }
        }
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.isScrollEnabled {
            return imageView
        }
        return nil
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let contentSize = scrollView.contentSize
        let boundsSize = scrollView.bounds
        
        let height = boundsSize.height - contentSize.height
        let width = boundsSize.width - contentSize.width
        
        if height > 0 {
            scrollView.contentInset.top = height/2
            scrollView.contentInset.bottom = height/2
        }
        else {
            scrollView.contentInset.top = 0
            scrollView.contentInset.bottom = 0
        }
        
        if width > 0 {
            scrollView.contentInset.left = width/2
            scrollView.contentInset.right = width/2
        }
        else {
            scrollView.contentInset.left = 0
            scrollView.contentInset.right = 0
        }
    }
}
