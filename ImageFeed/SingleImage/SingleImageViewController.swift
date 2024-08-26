//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/19/24.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet (value) {
            guard isViewLoaded, let image else { return }
            imageView.image = value
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    @IBOutlet private var scrollView: UIScrollView!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: .none)
        present(activityController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image else { return }
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        imageView.frame.size = image.size
        imageView.image = image

        rescaleAndCenterImageInScrollView(image: image)
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
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
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
