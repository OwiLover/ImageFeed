//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/15/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var avatarImageView: UIImageView?
    private var logoutButton: UIButton?
    private var nameLabel: UILabel?
    private var tagLabel: UILabel?
    private var descLabel: UILabel?
    private var exitButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack

        avatarImageView = addImageView(under: view, image: UIImage(named: "Photo"))
        
        logoutButton = addButton(nextTo: avatarImageView, image: UIImage(named: "Exit"), color: .ypRed)
        
        nameLabel = addLabel(under: avatarImageView, text: "Екатерина Новикова", font: UIFont.systemFont(ofSize: 23, weight: .bold), color: .ypWhite)
        tagLabel = addLabel(under: nameLabel, text: "@ekaterina_nov", font: UIFont.systemFont(ofSize: 13), color: .ypGray)
        descLabel = addLabel(under: tagLabel, text: "Hello, World!", font: UIFont.systemFont(ofSize: 13), color: .ypWhite)
    }
    
    private func addImageView(under someView: UIView?, image: UIImage?) -> UIImageView? {
        
        guard let someView else { return nil }
        
        let imageView = UIImageView(image: image ?? UIImage(systemName: "person.crop.circle.fill"))
        
        imageView.tintColor = .ypGray
    
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.topAnchor.constraint(equalTo: someView.safeAreaLayoutGuide.topAnchor, constant: 32),
            imageView.leadingAnchor.constraint(equalTo: someView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        
        return imageView
    }
    
    private func addButton(nextTo someView: UIView?, image: UIImage?, color: UIColor) -> UIButton? {
        guard let someView else { return nil }
        
        let button = UIButton()
        
        button.setTitle(.none, for: .normal)
        button.setImage(image, for: .normal)
        button.tintColor = color
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.centerYAnchor.constraint(equalTo: someView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
        
        return button
    }
    
    private func addLabel(under someView: UIView?, text: String?, font: UIFont, color: UIColor) -> UILabel? {
        guard let someView else { return nil }
        
        let label = UILabel()
        
        label.text = text
        label.font = font
        label.textColor = color
        
        view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: someView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: someView.leadingAnchor)
        ])
        
        return label
    }
}
